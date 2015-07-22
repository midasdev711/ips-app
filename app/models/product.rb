class Product < ActiveRecord::Base
  include Category
  include Tax

  belongs_to :product_list
  has_and_belongs_to_many :options

  validates :name, presence: true

  scope :misc_fees, -> { where(name: 'Misc. fees') }
  scope :visible, -> { where.not(name: 'Misc. fees') }

  monetize :retail_price_cents, :dealer_cost_cents, numericality: { greater_than_or_equal_to: 0 }

  def price
    return retail_price unless taxable?
    retail_price * (1 + product_list.listable.provincial_tax)
  end

  def profit
    retail_price - dealer_cost
  end

  class << self
    def price
      all.reduce(Money.new(0)) { |acc, p| acc + p.price }
    end

    def profit
      all.reduce(Money.new(0)) { |acc, p| acc + p.profit }
    end

    def tier
      profit.to_i / 1000
    end
  end

  private

  def taxable?
    tax? && product_list.listable.taxable?
  end
end
