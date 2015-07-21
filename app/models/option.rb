class Option < ActiveRecord::Base
  include LoanType
  include Residual
  include Amortization

  enum payment_frequency: [:biweekly, :monthly]

  attr_reader :balloon_payment, :cost_of_borrowing, :profit

  belongs_to :lender
  has_and_belongs_to_many :products

  has_many :insurance_terms
  has_many :insurance_policies, through: :insurance_terms

  accepts_nested_attributes_for :insurance_terms, allow_destroy: true

  validates :index, uniqueness: { scope: :lender }
  validates :payment_frequency, presence: true

  before_create :set_products, :set_insurance_terms, if: -> { lender.right? }
  before_create :add_misc_fees
  before_update :normalize_insurance_terms
  before_update :normalize_interest_rate, if: -> { lender.right? }

  def warnings
    @warnings ||= []
  end

  def deal
    lender.deal
  end

  def tier
    (categories.first.profit.to_f / 1000).ceil
  end

  def car_amount
    lender.car_amount
  end

  def sku
    'SKU %06d' % @profit
  end

  def categories
    @categories ||= Product.categories.map do |k, v|
      ProductCategory.new(name: k, products: products.where(category: v), insurance_terms: insurance_terms.where(category: v))
    end
  end

  def calculate
    @current_interest_rate = interest_rate
    @profit = 0
    amount = car_amount
    buydown_amount = 0

    categories.each do |category|
      amount += category.products.price + category.insurance_terms.fee(insurable_amount)
      category.profit = category.products.profit + category.insurance_terms.fee(insurable_amount) * deal.product_list.insurance_profit / 100
      @profit += category.profit

      if buydown?
        category_buydown_amount = category.profit - case category.name
        when 'pocketbook'
          Money.new(buydown_tier * 100000)
        when 'car'
          deal.product_list.car_profit
        when 'family'
          deal.product_list.family_profit
        end

        if category_buydown_amount > 0
          buydown_amount += category_buydown_amount
          @profit -= category_buydown_amount
        end

        ratio = 1 - buydown_amount / _cost_of_borrowing(amount, interest_rate)
        normalized_interest_rate = NormalizeInterestRate.execute(interest_rate * ratio)
        @current_interest_rate = interest_rate < normalized_interest_rate ? interest_rate : normalized_interest_rate
      end

      category.interest_rate = @current_interest_rate
      category.payment = _payment(amount)
    end

    @cost_of_borrowing = @current_interest_rate > 0 ? _cost_of_borrowing(amount) : Money.new(0)
    @balloon_payment = amortization.to_i > term ? BalloonPayment.execute(amount, NumberOfPayments.execute(term, payment_frequency), effective_interest_rate, finance_payment(amount)) : Money.new(0)

    normalize_buydown_tier

    self.warnings << "Loan amount exceeds #{lender.bank} approved maximum" if amount > lender.approved_maximum
    self.warnings << "Payment exceeds #{lender.bank} maximum" if _payment(amount) > deal.payment_max

    save
  end

  def add_misc_fees
    misc_fees = deal.product_list.misc_fees
    if misc_fees.present?
      self.products << misc_fees
    end
  end

  def interest_rates
    lender.interest_rates.map(&:value).uniq.sort
  end

  private

  def buydown?
    lender.right? && lender.finance? && term.present? && buydown_tier.present? && buydown_tier < tier
  end

  def effective_interest_rate(nominal_interest_rate = nil)
    nominal_interest_rate ||= @current_interest_rate
    EffectiveInterestRate.execute(nominal_interest_rate / 100, payment_frequency)
  end

  def money_factor(nominal_interest_rate = nil)
    nominal_interest_rate ||= @current_interest_rate
    MoneyFactor.execute(nominal_interest_rate / 100, payment_frequency)
  end

  def set_products
    self.products = deal.product_list.products
  end

  def set_insurance_terms
    insurance_terms = []

    _term = term.to_i > 84 ? 84 : term

    deal.product_list.insurance_policies.each do |policy|
      insurance_terms << InsuranceTerm.new(term: _term, insurance_policy: policy, category: policy.category)
    end

    self.insurance_terms = insurance_terms
  end

  def normalize_insurance_terms
    insurance_terms.each do |it|
      next if it.term.nil?
      it.term = term if it.term > term
    end
  end

  def number_of_payments
    NumberOfPayments.execute(amortization || term, payment_frequency)
  end

  def _payment(*args)
    finance? ? finance_payment(*args) : lease_payment(*args)
  end

  def finance_payment(amount, interest_rate = nil)
    FinancePayment.execute(amount, number_of_payments, effective_interest_rate(interest_rate))
  end

  def lease_payment(amount, interest_rate = nil)
    lease_payment = LeasePayment.execute(amount, residual, number_of_payments, money_factor(interest_rate))
    lease_payment * (1 + (taxable? ? deal.provincial_tax : 0))
  end

  def _cost_of_borrowing(*args)
    finance? ? finance_cost_of_borrowing(*args) : lease_cost_of_borrowing(*args)
  end

  def finance_cost_of_borrowing(amount, interest_rate = nil)
    FinanceCostOfBorrowing.execute(amount, number_of_payments, finance_payment(amount, interest_rate))
  end

  def lease_cost_of_borrowing(amount, interest_rate = nil)
    LeaseCostOfBorrowing.execute(amount, residual, number_of_payments, money_factor(interest_rate))
  end

  def insurable_amount
    car_amount + products.price
  end

  def taxable?
    deal.taxable?
  end

  def normalize_interest_rate
    self.interest_rate ||= interest_rate_was
  end

  def normalize_buydown_tier
    self.buydown_tier ||= tier
    self.buydown_tier = tier if buydown_tier > tier
  end
end
