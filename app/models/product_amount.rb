class ProductAmount
  STRATEGIES = {
    finance: proc { amount + tax },
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

  def tax
    @tax ||= amount * tax_rate
  end

  def amount
    @amount ||= product.retail_price
  end

  delegate :status_indian, :province, to: :deal

  def tax_rate
    return 0.0 if status_indian

    case product.tax
    when 'no'  then 0.0
    when 'one' then province.gst
    when 'two' then province.gst + province.pst
    end
  end
end
