require 'rails_helper'

RSpec.describe VehicleAmount, '#amount', type: :model do
  let(:cash_price)   { 40_000 }
  let(:dci)          {  1_000 }
  let(:trade_in)     { 20_000 }
  let(:rebate)       { 500 }
  let(:cash_down)    { 3_000 }
  let(:bank_reg_fee) { 600 }

  let(:lender) do
    double :lender,
      cash_price: cash_price,
      dci: dci,
      trade_in: trade_in,
      rebate: rebate,
      cash_down: cash_down,
      bank_reg_fee: bank_reg_fee
  end

  let(:vehicle_amount) { described_class.new(lender) }

  subject{ vehicle_amount.amount }

  it { is_expected.to eql(cash_price - dci - trade_in - rebate - cash_down + bank_reg_fee) }
end
