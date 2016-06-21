class FinanceCostOfBorrowing
  class << self
    def execute(opts)
      amount, payment, payments_number = opts.values_at :amount, :payment, :payments_number
      payment * payments_number - amount
    end
  end
end
