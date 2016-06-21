class EffectiveInterestRate
  class << self
    def execute(opts)
      interest_rate, payment_frequency = opts.values_at :interest_rate, :payment_frequency
      payments_number = PaymentsNumber.execute months: 12, payment_frequency: payment_frequency
      compounding_periods = CompoundingPeriods.execute payment_frequency
      (1 + interest_rate / compounding_periods) ** (compounding_periods / payments_number) - 1
    end
  end
end
