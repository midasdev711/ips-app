class NormalizeInterestRate
  BUYDOWN_RATES =  [0.0] + (1..100).step(0.5).map { |i| i - 0.51 }

  class << self
    def execute(interest_rate)
      BUYDOWN_RATES.detect { |r| r >= interest_rate }
    end
  end
end
