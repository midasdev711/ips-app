class InsuranceRate < ActiveRecord::Base
  include Term

  belongs_to :insurance_policy

  validates :value, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(:term) }
end
