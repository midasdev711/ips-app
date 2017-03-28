class ProductAmount
  include Taxable

  STRATEGIES = {
    finance: proc { amount + tax_amount },
    lease: proc { amount }
  }

  def self.calculate(deal:, lender:, product:)
    strategy = STRATEGIES[lender.loan.to_sym]

    new(deal: deal, product: product).apply(strategy)
  end

  def initialize(deal:, product:)
    @deal, @product = deal, product
  end

  def apply(strategy)
    instance_eval(&strategy)
  end

  private

  attr_reader :deal, :product

  def tax_amount
    @tax_amount ||= amount * tax_rate
  end

  def amount
    @amount ||= product.retail_price
  end

  delegate :status_indian, :province, :tax, to: :deal
end
