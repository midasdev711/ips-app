require 'rails_helper'

RSpec.describe Tax, '#total', type: :model do
  let(:zero_amount) { Money.new(0) }

  let(:pst) { Money.new(6_00) }
  let(:gst) { Money.new(5_00) }

  let(:no_taxation) { false }
  let(:tax_type)    { 'two' }

  let(:tax) { described_class.new(double :lender, no_taxation?: no_taxation, tax_type: tax_type) }

  before do
    allow(tax).to receive(:pst).with(no_args).and_return(pst)
    allow(tax).to receive(:gst).with(no_args).and_return(gst)
  end

  subject{ tax.total }

  context 'when no_taxation' do
    let(:no_taxation) { true }
    it { is_expected.to eql(Money.new(0)) }
  end

  context 'when one tax' do
    let(:tax_type) { 'one' }
    it { is_expected.to eql(gst) }
  end

  context 'when two tax' do
    let(:tax_type) { 'two' }
    it { is_expected.to eql(gst + pst) }
  end

  context 'when invalid tax' do
    let(:tax_type) { 'blablabla' }
    it { expect{ subject }.to raise_error RuntimeError }
  end
end
