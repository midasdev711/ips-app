class LeasePayment
  class << self
    def execute(opts)
      amount, residual, money_factor, payments_number = opts.values_at :amount, :residual, :money_factor, :payments_number
      depreciation_fee = (amount - residual) / payments_number
      finance_fee = (amount + residual) * money_factor
      (depreciation_fee + finance_fee).round
    end
  end
end
