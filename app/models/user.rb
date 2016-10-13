class User < ActiveRecord::Base
  devise :authenticatable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :dealership
  has_many :deals, dependent: :destroy
  has_many :clients, through: :deals, dependent: :destroy
  has_one :product_list, as: :listable, dependent: :destroy

  after_create :set_product_list, unless: :admin?

  def active_for_authentication?
    super && (admin? || dealership.active?)
  end

  def inactive_message
    dealership.deactivated? ? :locked : :inactive
  end

  def financial_manager?
    !admin?
  end

  def add_dealership(params)
    dealership = Dealership.create params
    dealership.product_list = product_list.deep_clone include: [:products, insurance_policies: [:insurance_rates]]
    dealership
  end

  private

  def set_product_list
    self.product_list = dealership.product_list.deep_clone include: [:products, insurance_policies: [:insurance_rates]]
  end
end
