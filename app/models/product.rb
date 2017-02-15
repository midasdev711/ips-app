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

  def self.amount
    all.reduce(Money.new(0)) { |acc, item| acc + item.amount }
  end

  def self.profit
    all.reduce(Money.new(0)) { |acc, item| acc + item.profit }
  end

  def amount
    retail_price * (tax_rate + 1)
  end

  def profit
    retail_price - dealer_cost
  end

  private

  delegate :status_indian, :province, to: :deal

  def deal
    product_list.listable
  end

  def tax_rate
    return 0.0 if status_indian

    case tax
    when 'no'  then 0.0
    when 'one' then province.gst
    when 'two' then province.gst + province.pst
    end
  end
end
