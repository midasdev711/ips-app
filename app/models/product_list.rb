class ProductList < ActiveRecord::Base
  belongs_to :listable, polymorphic: true
  has_many :products, autosave: true, dependent: :destroy
  has_many :insurance_policies, autosave: true, dependent: :destroy

  validates :car_reserved_profit_cents, :family_reserved_profit_cents, :insurance_profit_rate, numericality: { greater_than_or_equal_to: 0 }

  accepts_nested_attributes_for :products, allow_destroy: true
  accepts_nested_attributes_for :insurance_policies, allow_destroy: true

  after_initialize :set_defaults

  monetize :car_reserved_profit_cents, :family_reserved_profit_cents

  def master?
    listable.is_a? User
  end

  def insurance_profit
    (insurance_profit_rate * 100).to_i
  end

  def insurance_profit=(percent)
    self.insurance_profit_rate = (percent.to_f / 100).round 4
  end

  private

  def set_defaults
    self.car_reserved_profit ||= Money.new(1_000_00)
    self.family_reserved_profit ||= Money.new(1_000_00)

    self.insurance_profit_rate ||= 0.4
  end
end
