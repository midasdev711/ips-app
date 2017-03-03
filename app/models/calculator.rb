module Calculator
  FREQUENCIES = {
    monthly:     12,
    semimonthly: 24,
    biweekly:    26,
    weekly:      52
  }

  class Base
    include ActiveModel::Validations

    validates :amount, presence: true
    validates :frequency, inclusion: { in: FREQUENCIES.keys }
    validates :rate, numericality: { greater_than_or_equal_to: 0 }
    validates :term, numericality: { only_integer: true, greater_than: 0 }

    attr_accessor :amount, :frequency, :rate, :term
    attr_reader :cost_of_borrowing, :payment

    def initialize(opts = {})
      @amount, @frequency, @rate, @term = opts.values_at :amount, :frequency, :rate, :term
    end

    def calculate!
      return false unless valid?
      calculate
    end

    def calculate
      true
    end

    private

    def compounding_frequency
      FREQUENCIES[frequency]
    end

    def compounding_periods(months)
      return months if frequency == :monthly

      months / FREQUENCIES[:monthly] * compounding_frequency
    end

    def effective_rate
      rate / compounding_frequency
    end
  end

  class Finance < Base
    validates :amortization, numericality: { only_integer: true, greater_than_or_equal_to: :term }, allow_nil: true

    attr_accessor :amortization
    attr_reader :balloon

    def initialize(opts = {})
      @amortization = opts[:amortization]
      super
    end

    private

    def calculate
      @payment = calculate_payment
      @balloon = calculate_balloon
      @cost_of_borrowing = calculate_cost_of_borrowing
      true
    end

    def calculate_balloon
      if amortization.present?
        compounding_periods = compounding_periods(term)

        if rate.zero?
          amount - @payment * compounding_periods
        else
          amount * ((1 + effective_rate) ** compounding_periods) - @payment * ((1 + effective_rate) ** compounding_periods - 1) / effective_rate
        end
      else
        Money.new 0
      end
    end

    def calculate_cost_of_borrowing
      if rate.zero?
        Money.new 0
      else
        @payment * compounding_periods - amount
      end
    end

    def calculate_payment
      if rate.zero?
        amount / compounding_periods
      else
        amount * (effective_rate + effective_rate / ((1 + effective_rate) ** compounding_periods - 1))
      end
    end

    def compounding_periods(months=nil)
      super(months || amortization || term)
    end
  end

  class Lease < Base
    validates :residual, presence: true
    validates :tax, presence: true, numericality: { greater_than_or_equal_to: 0 }

    attr_accessor :residual, :tax, :lien, :rebate

    def initialize(opts = {})
      @residual, @tax, @lien, @rebate = opts.values_at :residual, :tax, :lien, :rebate
      super
    end

    private

    def calculate
      @payment = calculate_payment
      @cost_of_borrowing = calculate_cost_of_borrowing
      true
    end

    def lien_cost_of_borrowing
      return Money.new 0 if rate.zero?

      lien_payment * compounding_periods - lien
    end

    def lease_cost_of_borrowing
      return Money.new 0 if rate.zero?

      lease_payment * compounding_periods - (amount - residual)
    end

    def calculate_cost_of_borrowing
      cost_of_borrowing = lease_cost_of_borrowing * (1 + tax) + lien_cost_of_borrowing - rebate * tax

      return Money.new(0) if cost_of_borrowing < 0

      cost_of_borrowing
    end

    def lease_payment
      return (amount - residual) / compounding_periods if rate.zero?

      lease_cents = effective_rate * (residual.cents - amount.cents * (1 + effective_rate) ** compounding_periods) / ((1 + effective_rate) * (1 - (1 + effective_rate) ** compounding_periods))

      Money.new lease_cents
    end

    def lien_payment
      return lien / compounding_periods if rate.zero?

      lien * (effective_rate + effective_rate / ((1 + effective_rate) ** compounding_periods - 1))
    end

    def lease_payment_taxed
      lease_payment * (1 + tax)
    end

    def calculate_payment
      lease_payment_taxed + lien_payment
    end

    def compounding_periods
      super(term)
    end
  end
end
