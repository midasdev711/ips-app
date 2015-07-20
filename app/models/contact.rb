class Contact < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true

  validates :name, presence: true
  validates :phone, :email, presence: true, if:  Proc.new { |d| d.contactable_type == 'Dealership' }
end
