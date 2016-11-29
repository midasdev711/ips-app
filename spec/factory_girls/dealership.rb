FactoryGirl.define do
  factory :dealership do
    name        Faker::Company.name
    address     Faker::Address.street_address
    phone       Faker::PhoneNumber.phone_number
    status      :active
    province_id 'BC'

    association :principal, factory: :contact
  end
end
