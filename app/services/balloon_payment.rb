class BalloonPayment
  class << self
    def execute(amount, payments_number, effective_interest_rate, payment)
      balloon_payment = if effective_interest_rate.zero?
        amount - payment * payments_number
      else
        amount * ((1 + effective_interest_rate) ** payments_number) - payment * ((1 + effective_interest_rate) ** payments_number - 1) / effective_interest_rate
      end
      balloon_payment.round
    end
  end
end
