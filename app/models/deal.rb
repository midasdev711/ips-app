class Deal < ActiveRecord::Base
  include AASM
  include Province
  include Tax

  enum state: [:product_list, :worksheet, :option]

  PAYMENT_FREQUENCIES = [:biweekly, :monthly]

  belongs_to :user
  has_one :client, as: :contactable, class_name: 'Contact', dependent: :destroy
  has_one :product_list, as: :listable, dependent: :destroy
  has_many :lenders, autosave: true, dependent: :destroy, inverse_of: :deal

  accepts_nested_attributes_for :client
  accepts_nested_attributes_for :lenders

  validates :province_id, presence: true, on: :update

  validates_associated :client
  validates_associated :lenders

  before_create :set_province, :set_tax, :set_product_list, :set_lenders

  monetize :payment_min_cents, :payment_max_cents, numericality: { greater_than_or_equal_to: 0 }

  attr_writer :option

  def setup_options
    lenders.map(&:setup_options)
  end

  def option
    @option || default_option
  end

  def default_option
    case scenario
    when 1 then 1
    when 2 then 4
    when 3 then 5
    end
  end

  def options
    case scenario
    when 1 then [1, 2, 3]
    when 2 then [1, 2, 3, 4]
    when 3 then [4, 5]
    end
  end

  def vehicle_tax
    return 0 if status_indian

    percentage = if used
                   case tax
                   when 'no'  then 0
                   when 'one' then province.gst
                   when 'two' then province.gst + province.pst
                   end
                 else
                   province.gst + province.pst
                 end

    percentage.to_f / 100
  end

  def set_scenario
    lender_l, lender_r = lenders.order(:position)
    scenario = lender_r.finance? ? lender_l.finance? ? 1 : 2 : 3
    update_attribute(:scenario, scenario)
  end

  aasm column: :state, skip_validation_on_save: true do
    state :product_list, initial: true
    state :worksheet
    state :option

    event :product_list_done do
      transitions to: :worksheet
    end

    event :worksheet_done do
      transitions to: :option
    end
  end

  private

  def set_province
    self.province_id = user.dealership.province_id
  end

  def set_tax
    tax = 'no'
    tax = 'one' unless province.gst.zero?
    tax = 'two' unless province.pst.zero?
    self.tax = tax
  end

  def set_product_list
    self.product_list = user.product_list.deep_clone(include: [:products, insurance_policies: [:insurance_rates]])
  end

  def set_lenders
    lenders.build position: 'left', term: 60
    lenders.build position: 'right', term: 72
  end
end
