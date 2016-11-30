module Calculator
  FREQUENCY_BIWEEKLY = 26
  FREQUENCY_MONTHLY  = 12

  class Base
    include ActiveModel::Validations

    validates :amount, presence: true
    validates :frequency, inclusion: { in: [:biweekly, :monthly] }
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
      case frequency
      when :biweekly
        FREQUENCY_BIWEEKLY
      when :monthly
        FREQUENCY_MONTHLY
      end
    end

    def compounding_periods(months)
      case frequency
      when :biweekly
        months / FREQUENCY_MONTHLY * FREQUENCY_BIWEEKLY
      when :monthly
        months
      end
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
        cents = amount.cents * (effective_rate + effective_rate / ((1 + effective_rate) ** compounding_periods - 1))
        Money.new(cents)
      end
    end

    def compounding_periods(months=nil)
      super(months || amortization || term)
    end
  end

  class Lease < Base
    validates :residual, presence: true
    validates :tax, presence: true, numericality: { greater_than_or_equal_to: 0 }

    attr_accessor :residual, :tax

    def initialize(opts = {})
      @residual, @tax = opts.values_at :residual, :tax
      super
    end

    private

    def calculate
      @payment = calculate_payment
      @cost_of_borrowing = calculate_cost_of_borrowing
      true
    end

    def calculate_cost_of_borrowing
      if rate.zero?
        Money.new 0
      else
        @payment * compounding_periods - (amount - residual)
      end
    end

    def calculate_payment
      if rate.zero?
        payment = (amount - residual) / compounding_periods
      else
        cents = effective_rate * (residual.cents - amount.cents * (1 + effective_rate) ** compounding_periods) / ((1 + effective_rate) * (1 - (1 + effective_rate) ** compounding_periods))
        payment = Money.new cents
      end
      payment * (1 + tax)
    end

    def compounding_periods
      super(term)
    end
  end
end
