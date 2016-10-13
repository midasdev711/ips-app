class Dealership < ActiveRecord::Base
  include Province

  enum status: [ :active, :inactive, :deactivated ]

  has_one :principal, as: :contactable, class_name: 'Contact', dependent: :destroy
  has_one :product_list, as: :listable, autosave: true, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :province_id, :name, :address, :phone, :status, presence: true

  accepts_nested_attributes_for :principal, allow_destroy: true
  accepts_nested_attributes_for :product_list, allow_destroy: true

  before_create :build_product_list
  after_save :send_deactivtion_email, on: :update, if: -> (dealership) { dealership.deactivated? }

private

  def send_deactivtion_email
    return unless self.status_changed?
    users.each do |user|
      DealershipMailer.deactivation_notification(user)
    end
  end

end
