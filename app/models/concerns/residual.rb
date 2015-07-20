module Residual
  extend ActiveSupport::Concern

  included do
    enum residual_unit: [:dollar, :percent]
    monetize :residual_cents, numericality: { greater_than_or_equal_to: 0 }

    after_validation :set_residual
  end

  private

  def set_residual
    self.residual = dollar? ? residual_value : lender.msrp * residual_value / 100
  end
end
