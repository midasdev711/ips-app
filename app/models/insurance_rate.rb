class InsuranceRate < ActiveRecord::Base
  include Loan
  include Term

  TERMS = [12, 24, 36, 48, 60, 72, 84, 96]

  belongs_to :insurance_policy

  validates :value, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(:term) }

  Variation = Struct.new :id, :name, :loan, :residual

  VARIATIONS = [
    Variation.new('finance', 'Finance', 'finance', false),
    Variation.new('lease', 'Lease', 'lease', false),
    Variation.new('lease-with-residual', 'Lease with Residual', 'lease', true),
  ]
end
