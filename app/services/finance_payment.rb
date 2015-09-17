class FinancePayment
  class << self
    def execute(opts)
      amount, interest_rate, payments_number = opts.values_at :amount, :interest_rate, :payments_number
      return amount / payments_number if interest_rate.zero?
      finance_payment = amount * (interest_rate + interest_rate / ((1 + interest_rate) ** payments_number - 1))
      finance_payment.round
    end
  end
end
