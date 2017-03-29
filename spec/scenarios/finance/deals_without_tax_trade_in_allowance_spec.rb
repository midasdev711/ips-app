require 'rails_helper'

RSpec.describe 'Deals without tax trade id allowance', type: :scenario do

  let(:dealership) { create :dealership, province_id: 'SK' }
  let(:user) { create :user, dealership: dealership }

  let(:deal) { create :deal, user: user, pst_trade_in_allowance: pst_trade_in_allowance, gst_trade_in_allowance: gst_trade_in_allowance, status_indian: status_indian  }

  let(:interest_rate) { create :interest_rate, value: 0.09 }

  let(:cash_price)   { Money.new 40_000_00 }
  let(:dci)          { Money.new  1_000_00 }
  let(:trade_in)     { Money.new 20_000_00 }
  let(:bank_reg_fee) { Money.new         0 }
  let(:rebate)       { Money.new         0 }
  let(:cash_down)    { Money.new         0 }

  let(:tax_type)               { :two }
  let(:pst_trade_in_allowance) { false }
  let(:gst_trade_in_allowance) { false }
  let(:status_indian)          { false }

  before do
    deal.update(tax: tax_type)

    @lender, _ = deal.lenders
    @lender.update bank: Faker::Company.name, loan: :finance, frequency: :biweekly, term: 84, dci: dci, trade_in: trade_in, cash_price: cash_price, bank_reg_fee: bank_reg_fee, interest_rate: interest_rate, interest_rates: [interest_rate]

    @lender.calculate!
  end

  context 'when PST and GST trade-in allowance are disabled' do
    it { expect(@lender.payment).to eql(Money.new(169_80)) }
    it { expect(@lender.cost_of_borrowing).to eql(Money.new(8_003_60)) }
  end

  context 'when one tax' do
    let(:tax_type) { :one }

    it { expect(@lender.payment).to eql(Money.new(155_34)) }
    it { expect(@lender.cost_of_borrowing).to eql(Money.new(7_321_88)) }
  end

  context 'when no tax' do
    let(:tax_type) { :no }

    it { expect(@lender.payment).to eql(Money.new(140_89)) }
    it { expect(@lender.cost_of_borrowing).to eql(Money.new(6_641_98)) }
  end

  context 'when status indian' do
    let(:status_indian) { true }

    it { expect(@lender.payment).to eql(Money.new(140_89)) }
    it { expect(@lender.cost_of_borrowing).to eql(Money.new(6_641_98)) }
  end
end
