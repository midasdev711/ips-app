class BalloonPayment
  class << self
    def execute(opts)
      amount, interest_rate, payment, payments_number = opts.values_at :amount, :interest_rate, :payment, :payments_number
      balloon_payment = if interest_rate.zero?
        amount - payment * payments_number
      else
        amount * ((1 + interest_rate) ** payments_number) - payment * ((1 + interest_rate) ** payments_number - 1) / interest_rate
      end
      balloon_payment.round
    end
  end
end
