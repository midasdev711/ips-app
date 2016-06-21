class CompoundingPeriods
  class << self
    def execute(payment_frequency)
      case payment_frequency.to_sym
      when :monthly
        12
      when :biweekly
        26
      end
    end
  end
end
