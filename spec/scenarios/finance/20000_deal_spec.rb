require 'rails_helper'

RSpec.describe '$20,000 deal', type: :scenario do

  let(:dealership) { create :dealership, province_id: 'SK' }
  let(:user) { create :user, dealership: dealership }

  let(:deal) { create :deal, user: user, tax: :two }

  let(:interest_rate) { create :interest_rate, value: interest_rate_value }

  let(:cash_price)   { Money.new 20_000_00 }
  let(:bank_reg_fee) { Money.new 117_74 }

  before do
    @lender, _ = deal.lenders
    @lender.update bank: Faker::Company.name, loan: :finance, frequency: :biweekly, term: 84, cash_price: cash_price, bank_reg_fee: bank_reg_fee, interest_rate: interest_rate, interest_rates: [interest_rate]

    @lender.calculate!
  end

  [
    Example.new(0.0699, 155_22, 5_932_30),
    Example.new(0.0474, 144_20, 3_926_66),
    Example.new(0.0399, 140_64, 3_278_74),
    Example.new(0.0349, 138_29, 2_851_04),
    Example.new(0.0299, 135_98, 2_430_62),
    Example.new(0.0249, 133_68, 2_012_02),
    Example.new(0.0199, 131_41, 1_598_88),
    Example.new(0.0149, 129_17, 1_191_20),
    Example.new(0.0099, 126_95,   787_16),
    Example.new(0.0049, 124_75,   386_76),
    Example.new(0.0000, 122_62,        0)
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
