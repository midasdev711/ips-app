class InsurancePolicy < ActiveRecord::Base
  include Category
  include LoanType

  attr_accessor :prototype_id

  belongs_to :product_list
  has_many :insurance_rates, autosave: true, dependent: :destroy
  has_many :insurance_terms
  has_many :options, through: :insurance_terms

  accepts_nested_attributes_for :insurance_rates

  validates :name, presence: true

  after_initialize :set_insurance_rates, if: -> { insurance_rates.empty? }

  def description
    result = '%s [%s]' % [name, loan_type]
    if residual
      result += '[with residual]'
    end
    result
  end

  private

  def set_insurance_rates
    8.times do |i|
      insurance_rates << InsuranceRate.new(term: 12 * (i + 1))
    end
  end
end
