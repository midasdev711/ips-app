class MoneyFactor
  class << self
    def execute(nominal_interest_rate, payment_frequency)
      number_of_payments = NumberOfPayments.execute(12, payment_frequency)
      money_factor = nominal_interest_rate / 24 * 12 / number_of_payments # the 24 is 2400 / 100
      money_factor.round(8)
    end
  end
end
