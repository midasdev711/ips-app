class VehicleAmount
  STRATEGIES = {
    finance: proc { amount + tax },
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

  def base_amount
    @base_amount ||= cash_price - trade_in - dci
  end

  def tax
    @tax ||= base_amount.positive? ? base_amount * tax_rate : zero_amount
  end

  def amount
    @amount ||= base_amount + lien - rebate - cash_down + bank_reg_fee
  end

  private

  attr_reader :lender

  delegate :cash_price, :trade_in, :dci, :tax_rate, :lien, :rebate, :cash_down, :bank_reg_fee, :loan, to: :lender

  def zero_amount
    Money.new(0)
  end
end
