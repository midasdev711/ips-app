require 'rails_helper'

RSpec.describe VehicleAmount, '#tax', type: :model do
  let(:tax_rate) { 0.15 }


  let(:lender) { double :lender, tax_rate: tax_rate }
  let(:vehicle_amount) { described_class.new(lender) }

  before do
    allow(vehicle_amount).to receive(:base_amount).with(no_args).and_return(base_amount)
  end

  subject{ vehicle_amount.tax }

  context 'when base_amount >= 0' do
    let(:base_amount) { Money.new(1_000) }

    it { is_expected.to eql(base_amount * tax_rate) }
  end

  context 'when base_amount < 0' do
    let(:base_amount) { Money.new(-1_000) }
    it { is_expected.to eql Money.new(0) }
  end
end
