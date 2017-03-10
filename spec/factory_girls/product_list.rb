FactoryGirl.define do
  factory :product_list

  factory :blank_master_product_list, class: ProductList do
    car_reserved_profit_cents 100000
    family_reserved_profit_cents 50000
    insurance_profit_rate 0.4

    association :listable, factory: :admin
  end
end
