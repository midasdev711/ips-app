module Term
  extend ActiveSupport::Concern

  included do
    validates_numericality_of :term, only_integer: true
  end
end
