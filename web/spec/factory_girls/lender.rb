FactoryGirl.define do
  factory :lender do
    bank Faker::Company.name
  end
end
