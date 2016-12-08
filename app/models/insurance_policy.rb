class InsurancePolicy < ActiveRecord::Base
  include Category
  include Loan

  attr_accessor :prototype_id

  belongs_to :product_list
  has_many :insurance_rates, autosave: true, dependent: :destroy
  has_many :insurance_terms
  has_many :options, through: :insurance_terms

  accepts_nested_attributes_for :insurance_rates, allow_destroy: true

  validates :name, presence: true

  def has_lease_coverage_options?
    insurance_rates.pluck(:residual).uniq.count > 1
  end
end
