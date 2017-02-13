FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    email    { |n| "user+#{n}@example.com" }
    password Faker::Internet.password

    factory :admin do
      admin true
    end

    factory :manager do
      admin false
      association :dealership, factory: :dealership
    end
  end
end
