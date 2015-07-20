class FinanceCostOfBorrowing
  class << self
    def execute(amount, number_of_payments, payment)
      finance_cost_of_borrowing = payment * number_of_payments - amount
      finance_cost_of_borrowing.round
    end
  end
end
