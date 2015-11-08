class LeaseCostOfBorrowing
  class << self
    def execute(opts)
      amount, residual, money_factor, payments_number = opts.values_at :amount, :residual, :money_factor, :payments_number
      lease_cost_of_borrowing = (amount + residual) * payments_number * money_factor
      lease_cost_of_borrowing.round
    end
  end
end
