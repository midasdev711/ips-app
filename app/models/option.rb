class Option < ActiveRecord::Base
  include Loan

  attr_reader :balloon_payment, :cost_of_borrowing, :profit
  attr_reader :amount, :buydown_amount

  belongs_to :lender
  has_and_belongs_to_many :products
  has_many :insurance_terms
  has_many :insurance_policies, through: :insurance_terms
end
