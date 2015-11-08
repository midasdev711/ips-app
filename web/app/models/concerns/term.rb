module Term
  extend ActiveSupport::Concern

  included do
    validates :term, inclusion: { in: [12, 24, 36, 48, 60, 72, 84, 96] }
  end
end
