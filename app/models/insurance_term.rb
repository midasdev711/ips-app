class InsuranceTerm < ActiveRecord::Base
  include Term
  include Category

  belongs_to :option
  belongs_to :insurance_policy

  monetize :premium_cents, numericality: { greater_than_or_equal_to: 0 }

  class << self
    def premium
      all.reduce(Money.new(0)) { |acc, t| acc + t.premium }
    end
  end

  def calculate_premium(insurable_value)
    update(premium: insurable_value * insurance_rate) unless overridden
  end

  private

  def insurance_rate
    insurance_policy.insurance_rates.find_by(term: term).value / 100
  end
end
