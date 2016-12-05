class InsuranceTerm < ActiveRecord::Base
  include Term
  include Category
  
  belongs_to :lender
  belongs_to :option
  belongs_to :insurance_policy

  monetize :premium_cents, numericality: { greater_than_or_equal_to: 0 }

  delegate :insurance_rates, to: :insurance_policy
  delegate :loan, to: :lender

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
    insurance_rate = insurance_rates.find_by(loan: loan, residual: residual, term: term)

    if insurance_rate
      insurance_rate.value / 100
    else
      insurance_rate
      0.0
    end
  end
end
