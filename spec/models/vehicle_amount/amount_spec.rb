require 'rails_helper'

RSpec.describe VehicleAmount, '#amount', type: :model do
  let(:base_amount) { 6_000 }
  let(:rebate) { 500 }
  let(:cash_down) { 3_000 }
  let(:bank_reg_fee) { 600 }

  let(:lender) do
    double :lender,
      rebate: rebate,
      cash_down: cash_down,
      bank_reg_fee: bank_reg_fee
  end

  let(:vehicle_amount) { described_class.new(lender) }

  before do
    allow(vehicle_amount).to receive(:base_amount).with(no_args).and_return(base_amount)
  end

  subject{ vehicle_amount.amount }

  it { is_expected.to eql(base_amount - rebate - cash_down + bank_reg_fee) }
end
