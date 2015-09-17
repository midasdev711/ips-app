class FinancePayment
  class << self
    def execute(amount, payments_number, effective_interest_rate)
      return amount / payments_number if effective_interest_rate.zero?
      finance_payment = amount * (effective_interest_rate + effective_interest_rate / ((1 + effective_interest_rate) ** payments_number - 1))
      finance_payment.round
    end
  end
end
