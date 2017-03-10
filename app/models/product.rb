class Product < ActiveRecord::Base
  include Category
  include Tax

  belongs_to :product_list
  has_and_belongs_to_many :lenders
  has_and_belongs_to_many :options

  validates :name, presence: true

  scope :visible,   -> { where visible: true  }
  scope :invisible, -> { where visible: false }

  monetize :retail_price_cents, :dealer_cost_cents, numericality: { greater_than_or_equal_to: 0 }

  def self.profit
    all.reduce(Money.new(0)) { |acc, item| acc + item.profit }
  end

  def profit
    retail_price - dealer_cost
  end
end
