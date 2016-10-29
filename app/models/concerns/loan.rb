module Loan
  extend ActiveSupport::Concern

  included do
    enum loan: [:finance, :lease]
    validates :loan, presence: true
  end
end
