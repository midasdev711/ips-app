class NumberOfPayments
  class << self
    def execute(months, payment_frequency)
      case payment_frequency.to_sym
      when :monthly
        months
      when :biweekly
        months / 12 * 26
      end
    end
  end
end
