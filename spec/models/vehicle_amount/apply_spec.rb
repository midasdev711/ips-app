require 'rails_helper'

RSpec.describe VehicleAmount, '#apply', type: :model do
  let(:lender) { double :lender }
  let(:vehicle_amount) { described_class.new(lender) }

  let(:base_amount) { double :base_amount, negative?: base_amount_negative? }

  let(:strategy) { lambda{ 'boom' } }
  let(:strategy_amount) { double :strategy_amount }

  before do
    allow(vehicle_amount).to receive(:base_amount).with(no_args).and_return(base_amount)
    allow(vehicle_amount).to receive(:instance_eval).with(no_args, &strategy).and_return(strategy_amount)
  end

  subject{ vehicle_amount.apply(strategy) }

  context 'when base_amount is positive' do
    let(:base_amount_negative?) { false }

    it { is_expected.to eql(strategy_amount) }
  end

  context 'when base_amount is negative' do
    let(:base_amount_negative?) { true }

    it { is_expected.to eql(Money.new(0)) }
  end
end
