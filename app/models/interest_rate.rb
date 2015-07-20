class InterestRate < ActiveRecord::Base
  belongs_to :lender
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
