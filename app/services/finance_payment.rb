class FinancePayment
  class << self
    def execute(amount, number_of_payments, effective_interest_rate)
      return amount / number_of_payments if effective_interest_rate.zero?
      finance_payment = amount * (effective_interest_rate + effective_interest_rate / ((1 + effective_interest_rate) ** number_of_payments - 1))
      finance_payment.round
    end
  end
end
