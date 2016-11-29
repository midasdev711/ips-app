require 'rails_helper'

RSpec.describe VehicleAmount, '#base_amount', type: :model do
  let(:cash_price) { 18_000 }
  let(:trade_in) { 7_000 }
  let(:dci) { 500 }

  let(:lender) { double :lender, cash_price: cash_price, trade_in: trade_in, dci: dci }
  let(:vehicle_amount) { described_class.new(lender) }

  subject{ vehicle_amount.base_amount }

  it { is_expected.to eql(cash_price - trade_in - dci) }
end
