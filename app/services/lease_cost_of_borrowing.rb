class LeaseCostOfBorrowing
  class << self
    def execute(amount, residual, payments_number, money_factor)
      lease_cost_of_borrowing = (amount + residual) * payments_number * money_factor
      lease_cost_of_borrowing.round
    end
  end
end
