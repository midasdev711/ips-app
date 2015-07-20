class BalloonPayment
  class << self
    def execute(amount, number_of_payments, effective_interest_rate, payment)
      balloon_payment = if effective_interest_rate.zero?
        amount - payment * number_of_payments
      else
        amount * ((1 + effective_interest_rate) ** number_of_payments) - payment * ((1 + effective_interest_rate) ** number_of_payments - 1) / effective_interest_rate
      end
      balloon_payment.round
    end
  end
end
