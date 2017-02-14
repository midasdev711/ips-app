require 'rails_helper'

RSpec.describe VehicleAmount, '#apply', type: :model do
  let(:lender) { double :lender }
  let(:vehicle_amount) { described_class.new(lender) }

  let(:strategy) { lambda{ 'boom' } }
  let(:strategy_amount) { double :strategy_amount }

  before do
    allow(vehicle_amount).to receive(:instance_eval).with(no_args, &strategy).and_return(strategy_amount)
  end

  subject{ vehicle_amount.apply(strategy) }

  it { is_expected.to eql(strategy_amount) }
end
