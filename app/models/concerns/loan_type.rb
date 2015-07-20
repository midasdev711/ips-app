module LoanType
  extend ActiveSupport::Concern

  included do
    enum loan_type: [:finance, :lease]
    validates :loan_type, presence: true
  end
end
