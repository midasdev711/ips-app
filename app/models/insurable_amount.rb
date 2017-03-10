class InsurableAmount
  attr_reader :lender

  delegate :build_calculator, :vehicle_amount, :products_amount, to: :lender

  def self.calculate(lender)
    new(lender).amount
  end

  def initialize(lender)
    @lender = lender
    @calculator = build_calculator
  end

  def amount
    @calculator.amount = products_amount + vehicle_amount
    @calculator.calculate!
    @calculator.amount + @calculator.cost_of_borrowing
  end
end
