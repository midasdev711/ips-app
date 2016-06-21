class LeaseCostOfBorrowing
  class << self
    def execute(opts)
      amount, residual, money_factor, payments_number = opts.values_at :amount, :residual, :money_factor, :payments_number
      (amount + residual) * payments_number * money_factor
    end
  end
end
