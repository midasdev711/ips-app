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
    Example.new(0.0699, 153_83, 5_879_32),
    Example.new(0.0474, 142_91, 3_891_88),
    Example.new(0.0399, 139_38, 3_249_42),
    Example.new(0.0349, 137_06, 2_827_18),
    Example.new(0.0299, 134_76, 2_408_58),
    Example.new(0.0249, 132_48, 1_993_62),
    Example.new(0.0199, 130_23, 1_584_12),
    Example.new(0.0149, 128_01, 1_180_08),
    Example.new(0.0099, 125_81,   779_68),
    Example.new(0.0049, 123_63,   382_92),
    Example.new(0.0000, 121_53,        0)
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
