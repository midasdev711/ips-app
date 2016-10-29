FactoryGirl.define do
  factory :calculator, class: Calculator::Base do
    amount Money.new(100)
    frequency :biweekly
    rate 0.05
    term 36

    factory :finance, class: Calculator::Finance do
      loan :finance
    end

    factory :finance_with_balloon, class: Calculator::Finance do
      amortization 48
    end

    factory :lease, class: Calculator::Lease do
      loan :lease
      residual Money.new(40)
      tax 0.12
    end
  end
end
