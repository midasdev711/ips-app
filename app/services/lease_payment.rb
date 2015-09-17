class LeasePayment
  class << self
    def execute(amount, residual, payments_number, money_factor)
      depreciation_fee = (amount - residual) / payments_number
      finance_fee = (amount + residual) * money_factor
      (depreciation_fee + finance_fee).round
    end
  end
end
