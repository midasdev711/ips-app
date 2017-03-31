require 'rails_helper'

RSpec.describe Tax, '#calculate_taxable_amount', type: :model do
  let(:type)       { :pst }
  let(:cash_price) { 40_000 }
  let(:dci)        {  1_000 }
  let(:trade_in)   { 20_000 }

  let(:lender) { double :lender, cash_price: cash_price, dci: dci, trade_in: trade_in }
  let(:tax)    { described_class.new(lender) }

  before do
    allow(lender).to receive(:tax_trade_in_not_allowed?).with(type)
      .and_return(!tax_trade_in_allowance)
  end

  subject{ tax.calculate_taxable_amount(type) }

  context 'when no trade in allowance is enabled for given tax' do
    let(:tax_trade_in_allowance) { true }
    it { is_expected.to eql(cash_price - dci - trade_in) }
  end

  context 'when no trade in allowance is disabled for given tax' do
    let(:tax_trade_in_allowance) { false }
    it { is_expected.to eql(cash_price - dci) }
  end
end
