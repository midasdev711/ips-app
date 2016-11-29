require 'rails_helper'

RSpec.describe VehicleAmount, '#tax', type: :model do
  let(:tax_rate) { 0.15 }
  let(:base_amount) { 6_000 }

  let(:lender) { double :lender, tax_rate: tax_rate }
  let(:vehicle_amount) { described_class.new(lender) }

  before do
    allow(vehicle_amount).to receive(:base_amount).with(no_args).and_return(base_amount)
  end

  subject{ vehicle_amount.tax }

  it { is_expected.to eql(base_amount * tax_rate) }
end
