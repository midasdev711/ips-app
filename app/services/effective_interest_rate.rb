class EffectiveInterestRate
  class << self
    def execute(opts)
      interest_rate, payment_frequency = opts.values_at :interest_rate, :payment_frequency
      payments_number = PaymentsNumber.execute months: 12, payment_frequency: payment_frequency
      compounding_periods = 2.0 # semi annually in Canada
      effective_interest_rate = (1 + interest_rate / compounding_periods) ** (compounding_periods / payments_number) - 1
      effective_interest_rate.round(4)
    end
  end
end
