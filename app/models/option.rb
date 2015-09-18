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
  before_update :normalize_insurance_terms
  before_update :normalize_interest_rate, if: -> { lender.right? }

  def warnings
    @warnings ||= []
  end

  def deal
    lender.deal
  end

  def tier
    products.pocketbook.tier
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
    insurance_terms.map { |insurance_term| insurance_term.calculate_premium insurable_value }

    @current_interest_rate = interest_rate
    @profit = Money.new(0)
    amount = car_amount
    buydown_amount = Money.new(0)

    categories.each do |category|
      amount += category.products.price + category.insurance_terms.premium
      category.profit = category.products.profit + category.insurance_terms.premium * deal.product_list.insurance_profit / 100
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
    @balloon_payment = amortization.to_i > term ? BalloonPayment.execute(amount: amount, interest_rate: effective_interest_rate, payment: finance_payment(amount), payments_number: PaymentsNumber.execute(months: term, payment_frequency: payment_frequency)) : Money.new(0)

    self.warnings << "Loan amount exceeds #{lender.bank} approved maximum" if amount > lender.approved_maximum
    self.warnings << "Payment exceeds #{lender.bank} maximum" if _payment(amount) > deal.payment_max
  end

  def add_misc_fees
    misc_fees = deal.product_list.misc_fees
    if misc_fees && products.exclude?(misc_fees)
      self.products << misc_fees
    end
  end

  def interest_rates
    lender.interest_rates.map(&:value).uniq.sort
  end

  private

  def buydown?
    lender.right? && lender.finance? && buydown_tier.present? && buydown_tier <= tier
  end

  def set_products
    self.products = deal.product_list.products.visible
  end

  def set_insurance_terms
    insurance_terms = []

    _term = term.to_i > 84 ? 84 : term

    deal.product_list.insurance_policies.group_by(&:name).each do |name, policies|
      policies = policies.select { |p| p.loan_type == loan_type }

      if lease? && policies.size > 1
        policies = policies.select { |p| p.residual == residual > 0 }
      end

      policies.each do |policy|
        insurance_terms << InsuranceTerm.new(term: _term, insurance_policy: policy, category: policy.category)
      end
    end

    self.insurance_terms = insurance_terms
  end

  def normalize_insurance_terms
    insurance_terms.each do |it|
      next if it.term.nil?
      it.term = term if it.term > term
    end
  end

  def normalize_interest_rate
    self.interest_rate ||= interest_rate_was
  end

  def insurable_value
    car_amount + products.price + _cost_of_borrowing(car_amount + products.price, interest_rate)
  end

  def effective_interest_rate(interest_rate = nil)
    interest_rate ||= @current_interest_rate
    EffectiveInterestRate.execute interest_rate: (interest_rate / 100), payment_frequency: payment_frequency
  end

  def money_factor(interest_rate = nil)
    interest_rate ||= @current_interest_rate
    MoneyFactor.execute interest_rate: (interest_rate / 100), payment_frequency: payment_frequency
  end

  def payments_number
    PaymentsNumber.execute months: (amortization || term), payment_frequency: payment_frequency
  end

  def _payment(*args)
    finance? ? finance_payment(*args) : lease_payment(*args)
  end

  def finance_payment(amount, interest_rate = nil)
    FinancePayment.execute amount: amount, interest_rate: effective_interest_rate(interest_rate), payments_number: payments_number
  end

  def lease_payment(amount, interest_rate = nil)
    lease_payment = LeasePayment.execute amount: amount, residual: residual, money_factor: money_factor(interest_rate), payments_number: payments_number
    lease_payment * (1 + deal.vehicle_tax)
  end

  def _cost_of_borrowing(*args)
    finance? ? finance_cost_of_borrowing(*args) : lease_cost_of_borrowing(*args)
  end

  def finance_cost_of_borrowing(amount, interest_rate = nil)
    FinanceCostOfBorrowing.execute amount: amount, payment: finance_payment(amount, interest_rate), payments_number: payments_number
  end

  def lease_cost_of_borrowing(amount, interest_rate = nil)
    LeaseCostOfBorrowing.execute amount: amount, residual: residual, money_factor: money_factor(interest_rate), payments_number: payments_number
  end
end
