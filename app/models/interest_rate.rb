class InterestRate < ActiveRecord::Base
  belongs_to :lender
  validates :value, :percent_value, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order :value }

  ROUNDED_RATES =  [0.0] + (1..50).step(0.5).map { |i| i - 0.51 }

  def percent_value
    (value.to_f * 100).round 4
  end

  def percent_value=(percent_value)
    self.value = (percent_value.to_f / 100.0).round 4
  end

  def round!
    self.percent_value = ROUNDED_RATES.detect { |r| r >= percent_value }
  end
end
