class EffectiveInterestRate
  class << self
    def execute(nominal_interest_rate, payment_frequency)
      number_of_payments = NumberOfPayments.execute(12, payment_frequency)
      compounding_periods = 2.0 # semi annually in Canada
      effective_interest_rate = (1 + nominal_interest_rate / compounding_periods) ** (compounding_periods / number_of_payments) - 1
      effective_interest_rate.round(4)
    end
  end
end
