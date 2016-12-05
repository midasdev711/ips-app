class Lender < ActiveRecord::Base
  include Loan
  include Term
  
  TERMS = [12, 24, 36, 48, 60, 72, 84, 96]

  enum frequency: [:biweekly, :monthly, :semimonthly, :weekly]
  enum position: [:left, :right]
  enum residual_unit: [:dollar, :percent]

  belongs_to :deal
  has_one :product_list, through: :deal

  belongs_to :interest_rate
  has_many :interest_rates, dependent: :destroy
  has_many :options, dependent: :destroy

  has_and_belongs_to_many :products
  has_many :insurance_terms
  has_many :insurance_policies, through: :insurance_terms

  validates :amortization, numericality: { greater_than_or_equal_to: :term, allow_nil: true }
  validates :bank, :frequency, :position, presence: true
  validates :position, uniqueness: { scope: :deal }
  validate :has_at_least_one_interest_rate

  accepts_nested_attributes_for :interest_rates, :insurance_terms, allow_destroy: true

  default_scope { order(:position) }

  monetize :max_amount_cents, :bank_reg_fee_cents, :cash_down_cents, :cash_price_cents, :dci_cents, :lien_cents, :msrp_cents, :rebate_cents, :residual_cents, :trade_in_cents, numericality: { greater_than_or_equal_to: 0 }

  delegate :tax_rate, to: :deal

  after_validation :set_residual

  attr_reader :calculator
  attr_reader :amount, :balloon, :buy_down_amount, :cost_of_borrowing, :payment, :profit
  attr_reader :warnings

  def sku
    'SKU %06d' % profit
  end

  def buydown?
    tier.present?
  end

  def calculate!
    min_rate, max_rate = interest_rates_minmax
    @interest_rates = interest_rates.to_a
    min_rate_index = @interest_rates.index min_rate
    max_rate_index = @interest_rates.index max_rate

    @current_rate = interest_rate
    @current_rate_index = @interest_rates.index @current_rate

    @amount = vehicle_amount

    calculator.amount = @amount
    calculator.calculate!

    @buy_down_amount, @profit = Money.new(0), Money.new(0)

    product_categories.each do |category|
      @amount += category.amount
      @profit += category.profit

      calculator.amount = @amount

      if right? # All the magic happens for the right-hand-side lender.
        if buydown? # Buy Down engaged.
          category_buy_down_amount = category.buy_down_amount

          if category_buy_down_amount.positive?
            @buy_down_amount += category_buy_down_amount

            calculator.rate = interest_rate.value
            calculator.calculate!

            cost_of_borrowing = calculator.cost_of_borrowing

            ratio = 1 - @buy_down_amount / cost_of_borrowing
            ratio = 0 if ratio < 0

            @current_rate = InterestRate.new value: (interest_rate.value * ratio).round(4)

            @current_rate.round! if rounding
          end
        else
          case category.name
          when 'pocketbook' # Each deselected product from pocketbook changes the interest rate to the next highest rate available.
            case category.count
            when 0 # If no pocketbook products selected, the baseline interest rate is the maximum rate available.
              @current_rate_index = max_rate_index
            else
              category.unselected_count.times do
                break if @current_rate_index == max_rate_index
                @current_rate_index += 1
              end
            end
          else # Each selected product from other categories changes the interest rate to the next lowest rate available.
            category.count.times do
              break if @current_rate_index == min_rate_index
              @current_rate_index -= 1
            end
          end

          @current_rate = @interest_rates[@current_rate_index]
        end
      end

      calculator.rate = @current_rate.value
      calculator.calculate!

      category.interest_rate = @current_rate
      category.payment = calculator.payment
    end

    @payment = calculator.payment
    @balloon = calculator.balloon if finance?
    @cost_of_borrowing = calculator.cost_of_borrowing

    if kickback # Optional 15% bank kick-back.
      @buy_down_amount *= 0.85
    end

    @profit -= @buy_down_amount

    self
  end

  def reset!
    transaction do
      reset_interest_rate
      reset_insurance_terms
      reset_products
    end

    save!
  end

  def vehicle_amount
    @vehicle_amount ||= VehicleAmount.calculate(self)
  end

  def products_amount
    (invisible_products + products).reduce(Money.new(0)) { |acc, item| acc + item.retail_price }
  end

  def insurable_amount
    amount = products_amount + vehicle_amount

    calculator.amount = amount
    calculator.rate = interest_rate.value
    calculator.calculate!

    amount + calculator.cost_of_borrowing
  end

  def max_tier
    pocketbook_profit.cents / 1_000_00
  end

  def product_categories
    @product_categories ||= Product.categories.map { |k, _| ProductCategory.new name: k, product_list: product_list, lender: self }
  end

  def warnings
    @warnings ||= []
  end

  def warnings?
    amount_warnings? || payment_warnings?
  end

  def invisible_products
    product_list.products.invisible
  end

  private

  def has_at_least_one_interest_rate
    if interest_rates.empty?
      errors.add(:interest_rates, 'must have at least one rate')
    end
  end

  def set_residual
    self.residual = case residual_unit
                    when 'dollar'
                      residual_value
                    when 'percent'
                      residual_value / 100 * msrp
                    end
  end

  def interest_rates_minmax
    interest_rates.minmax_by &:value
  end

  def insurance_policies_grouped_by_name
    product_list.insurance_policies.where(loan: loan).group_by(&:name)
  end

  def pocketbook_profit
    invisible_products.pocketbook.profit + products.pocketbook.profit
  end

  def reset_interest_rate
    min, max = interest_rates_minmax

    self.interest_rate = case position
                         when 'left'  then max
                         when 'right' then min
                         end
    true
  end

  def reset_insurance_terms
    insurance_terms.destroy_all

    if right?
      product_list.insurance_policies.includes(:insurance_rates).where('insurance_rates.loan' => loan).references(:insurance_rates).each do |insurance_policy|
        insurance_terms.create! category: insurance_policy.category, insurance_policy: insurance_policy, term: term
      end
    end

    true
  end

  def reset_products
    self.products = case position
                    when 'left'  then []
                    when 'right' then product_list.products.visible
                    end
    true
  end

  def calculator
    opts = { frequency: frequency.to_sym, rate: interest_rate.value, term: term }

    @calculator ||= case loan
                  when 'finance'
                    opts.merge! amortization: amortization
                    Calculator::Finance.new opts
                  when 'lease'
                    opts.merge! residual: residual, tax: tax_rate
                    Calculator::Lease.new opts
                  end
  end

  Warning = Struct.new(:field, :message)

  def amount_warnings?
    if amount > max_amount
      self.warnings << Warning.new(:amount, I18n.t('lender.warnings.messages.amount', bank: bank))
      true
    else
      false
    end
  end

  def payment_warnings?
    if payment > deal.max_payment
      self.warnings << Warning.new(:payment, I18n.t('lender.warnings.messages.payment', bank: bank))
      true
    else
      false
    end
  end
end
