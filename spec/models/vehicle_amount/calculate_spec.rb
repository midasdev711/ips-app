require 'rails_helper'

RSpec.describe VehicleAmount, '.calculate', type: :model do
  let(:lender) { double :lender, loan: 'foobar' }
  let(:vehicle_amount) { double :vehicle_amount }

  let(:strategy) { double :strategy }
  let(:strategy_result) { double :strategy_result }

  before do
    allow(described_class::STRATEGIES).to receive(:[]).with(lender.loan.to_sym).and_return(strategy)
    allow(described_class).to receive(:new).with(lender).and_return(vehicle_amount)
    allow(vehicle_amount).to receive(:apply).with(strategy).and_return(strategy_result)
  end

  subject { described_class.calculate(lender) }

  it { is_expected.to eql(strategy_result) }
end
