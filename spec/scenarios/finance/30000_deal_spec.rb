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
    Example.new(0.0699, 230_34, 8_804_14),
    Example.new(0.0474, 213_98, 5_826_62),
    Example.new(0.0399, 208_70, 4_865_66),
    Example.new(0.0349, 205_22, 4_232_30),
    Example.new(0.0299, 201_78, 3_606_22),
    Example.new(0.0249, 198_37, 2_985_60),
    Example.new(0.0199, 195_00, 2_372_26),
    Example.new(0.0149, 191_67, 1_766_20),
    Example.new(0.0099, 188_38, 1_167_42),
    Example.new(0.0049, 185_12,   574_10),
    Example.new(0.0000, 181_97,        0)
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

