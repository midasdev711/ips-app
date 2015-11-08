class MoneyFactor
  class << self
    def execute(opts)
      interest_rate, payment_frequency = opts.values_at :interest_rate, :payment_frequency
      payments_number = PaymentsNumber.execute months: 12, payment_frequency: payment_frequency
      money_factor = interest_rate / 24 * 12 / payments_number # the 24 is 2400 / 100
      money_factor.round 8
    end
  end
end
