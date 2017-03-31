require 'rails_helper'

RSpec.describe Tax, '#calculate', type: :model do
  let(:zero_amount) { Money.new(0) }

  let(:type)              { :pst }
  let(:taxation_disabled) { false }
  let(:taxable_amount)    { 100_00 }

  let(:lender) { double :lender, no_taxation?: taxation_disabled }
  let(:tax) { described_class.new(lender) }

  before do
    allow(tax).to receive(:calculate_taxable_amount).with(type)
      .and_return(taxable_amount)
  end

  subject{ tax.calculate(type) }

  context 'when no taxation' do
    let(:taxation_disabled) { true }

    it { is_expected.to eql zero_amount }
  end

  context 'taxable amount is negative' do
    let(:taxable_amount) { Money.new(-1_00) }

    it { is_expected.to eql zero_amount }
  end

  context 'when taxable amount is positive' do
    let(:tax_rate) { 0.06 }

    before do
      allow(lender).to receive(:pst_rate).with(no_args)
        .and_return(tax_rate)
    end

    it { is_expected.to eql(taxable_amount * tax_rate) }
  end
end
