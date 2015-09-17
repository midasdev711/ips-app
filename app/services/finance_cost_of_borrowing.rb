class FinanceCostOfBorrowing
  class << self
    def execute(amount, payments_number, payment)
      finance_cost_of_borrowing = payment * payments_number - amount
      finance_cost_of_borrowing.round
    end
  end
end
