class MoneyFactor
  class << self
    def execute(nominal_interest_rate, payment_frequency)
      payments_number = PaymentsNumber.execute(12, payment_frequency)
      money_factor = nominal_interest_rate / 24 * 12 / payments_number # the 24 is 2400 / 100
      money_factor.round(8)
    end
  end
end
