require 'rails_helper'

RSpec.describe InsuranceTerm, type: :model do

  it { is_expected.to belong_to :lender }
  it { is_expected.to belong_to :insurance_policy }

  describe '.amount' do
    subject { described_class.amount money }

    let(:money_class) { class_double('Money').as_stubbed_const }
    let(:money)       { double :money }

    let(:insurance_term)            { double :insurance_term, amount!: money }
    let(:insurance_term_collection) { [insurance_term] }

    before do
      allow(money_class).to receive(:new).and_return money
      allow(money).to receive(:+).with(money).and_return money

      allow(described_class).to receive(:all).and_return insurance_term_collection
    end

    it { is_expected.to eq money }
  end

  describe '#amount!' do
    subject { insurance_term.send :amount!, money }

    let(:insurance_term) { build :insurance_term }

    let(:insurance_rate) { double :insurance_rate }
    let(:money)          { double :money }

    before do
      allow(insurance_term).to receive(:insurance_rate).and_return insurance_rate
      allow(insurance_term).to receive(:premium).and_return money
      allow(insurance_term).to receive(:overridden).and_return overridden

      allow(money).to receive(:*).with(insurance_rate).and_return money
    end

    context 'when amount is calculated' do
      let(:overridden) { false }

      before do
        expect(insurance_term).to receive(:update).with premium: money
      end

      it { is_expected.to eq money }
    end

    context 'when amount is manually overridden' do
      let(:overridden) { true }

      it { is_expected.to eq money }
    end
  end
end
