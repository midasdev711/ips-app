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
    retail_price + tax_amount
  end

  def profit
    retail_price - dealer_cost
  end

  private

  def tax_percentage
    deal = product_list.listable

    return 0 if deal.status_indian

    province = deal.province

    percentage = case tax
                 when 'no'  then 0
                 when 'one' then province.gst
                 when 'two' then province.gst + province.pst
                 end

    percentage.to_f / 100
  end

  def tax_amount
    retail_price * tax_percentage
  end
end
