class InsuranceTerm < ActiveRecord::Base
  include Term
  include Category

  belongs_to :option
  belongs_to :insurance_policy

  def fee(insurable_value)
    insurance_rate = insurance_policy.insurance_rates.where(term: term).first.value / 100
    insurable_value * insurance_rate
  end

  class << self
    def fee(insurable_value)
      all.reduce(Money.new(0)) { |acc, t| acc + t.fee(insurable_value) }
    end
  end
end
