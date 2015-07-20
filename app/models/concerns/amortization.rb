module Amortization
  extend ActiveSupport::Concern

  included do
    validates :amortization, numericality: { greater_than_or_equal_to: :term, allow_nil: true }
  end
end
