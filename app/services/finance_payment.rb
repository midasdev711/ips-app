class FinancePayment
  class << self
    def execute(opts)
      amount, interest_rate, payments_number = opts.values_at :amount, :interest_rate, :payments_number
      if interest_rate.zero?
        amount / payments_number
      else
        cents = (amount.cents * (interest_rate + interest_rate / ((1 + interest_rate) ** payments_number - 1))).ceil
        Money.new(cents)
      end
    end
  end
end
