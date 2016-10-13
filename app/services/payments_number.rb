class PaymentsNumber
  class << self
    def execute(opts)
      months, payment_frequency = opts.values_at :months, :payment_frequency
      case payment_frequency.to_sym
      when :monthly
        months
      when :biweekly
        months / 12 * 26
      end
    end
  end
end
