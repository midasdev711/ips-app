class VehicleAmount
  STRATEGIES = {
    finance: proc { amount + lien + tax.total },
    lease: proc { amount }
  }

  def self.calculate(lender)
    strategy = STRATEGIES[lender.loan.to_sym]

    new(lender).apply(strategy)
  end

  def initialize(lender)
    @lender = lender
  end

  def apply(strategy)
    instance_eval(&strategy)
  end

  def amount
    cash_price - trade_in - dci - rebate - cash_down + bank_reg_fee
  end

  private

  attr_reader :lender

  delegate :cash_price, :trade_in, :dci, :lien, :rebate, :cash_down, :bank_reg_fee, :tax, to: :lender

  def zero_amount
    Money.new(0)
  end
end
