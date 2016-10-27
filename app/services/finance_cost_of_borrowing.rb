class FinanceCostOfBorrowing
  def self.execute(opts)
    amount, payment, payments_number = opts.values_at :amount, :payment, :payments_number
    payment * payments_number - amount
  end
end
