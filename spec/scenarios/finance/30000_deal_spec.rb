require 'rails_helper'

RSpec.describe '$30,000 deal', type: :scenario do

  let(:dealership) { create :dealership, province_id: 'SK' }
  let(:user) { create :user, dealership: dealership }

  let(:deal) { create :deal, user: user, tax: :two }

  let(:interest_rate) { create :interest_rate, value: interest_rate_value }

  let(:cash_price)   { Money.new 30_000_00 }
  let(:bank_reg_fee) { Money.new 117_74 }

  before do
    @lender, _ = deal.lenders
    @lender.update bank: Faker::Company.name, loan: :finance, frequency: :biweekly, term: 84, cash_price: cash_price, bank_reg_fee: bank_reg_fee, interest_rate: interest_rate, interest_rates: [interest_rate]

    @lender.calculate!
  end

  [
    Example.new(0.0699, 23_243, 8_884_52),
    Example.new(0.0474, 21_592, 5_879_70),
    Example.new(0.0399, 21_059, 4_909_64),
    Example.new(0.0349, 20_708, 4_270_82),
    Example.new(0.0299, 20_360, 3_637_46),
    Example.new(0.0249, 20_017, 3_013_20),
    Example.new(0.0199, 19_677, 2_394_40),
    Example.new(0.0149, 19_341, 1_782_88),
    Example.new(0.0099, 19_008, 1_176_82),
    Example.new(0.0049, 18_680,   579_86),
    Example.new(0.0000, 18_361,        0)
  ].each do |item|
    context "at #{item.rate}%" do
      let(:interest_rate_value) { item.rate }

      let(:expected_payment) { Money.new item.payment }
      let(:expected_cost_of_borrowing) { Money.new item.cost_of_borrowing }

      it { expect(@lender.payment).to eq expected_payment }
      it { expect(@lender.cost_of_borrowing).to eq expected_cost_of_borrowing }
    end
  end
end

