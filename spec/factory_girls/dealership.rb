FactoryGirl.define do
  factory :dealership do
    name    Faker::Company.name
    address Faker::Address.street_address
    phone   Faker::PhoneNumber.phone_number
  end
end
