class InsuranceTerm < ActiveRecord::Base
  include Term
  include Category

  belongs_to :lender
  belongs_to :option
  belongs_to :insurance_policy

  monetize :premium_cents, numericality: { greater_than_or_equal_to: 0 }

  def self.amount(insurable_amount)
    all.reduce(Money.new(0)) { |acc, item| acc + item.amount!(insurable_amount) }
  end

  def amount!(insurable_amount)
    unless overridden
      update premium: insurable_amount * insurance_rate
    end
    premium
  end

private

  def insurance_rate
    insurance_policy.insurance_rates.find_by(term: term).value / 100
  end
end
