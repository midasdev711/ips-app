class FinanceCostOfBorrowing
  class << self
    def execute(opts)
      amount, payment, payments_number = opts.values_at :amount, :payment, :payments_number
      finance_cost_of_borrowing = payment * payments_number - amount
      finance_cost_of_borrowing.round
    end
  end
end
