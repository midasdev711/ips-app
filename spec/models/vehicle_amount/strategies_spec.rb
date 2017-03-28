require 'rails_helper'

RSpec.describe VehicleAmount, 'strategies', type: :model do
  let(:amount) { 15_000 }
  let(:tax) { double :tax, total: 500 }
  let(:lien) { 2_000 }

  let(:vehicle_amount) { double :vehicle_amount, amount: amount, tax: tax, lien: lien }

  subject{ vehicle_amount.instance_eval(&strategy) }

  context 'finance' do
    let(:strategy) { VehicleAmount::STRATEGIES[:finance] }

    it { is_expected.to eql(amount + lien + tax.total) }
  end

  context 'lease' do
    let(:strategy) { VehicleAmount::STRATEGIES[:lease] }

    it { is_expected.to eql(amount) }
  end
end
