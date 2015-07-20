class LeaseCostOfBorrowing
  class << self
    def execute(amount, residual, number_of_payments, money_factor)
      lease_cost_of_borrowing = (amount + residual) * number_of_payments * money_factor
      lease_cost_of_borrowing.round
    end
  end
end
