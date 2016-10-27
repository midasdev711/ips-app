require 'rails_helper'

RSpec.describe InsuranceTerm, type: :model do

  describe '#calculate_premium!' do

    let(:insurable_value) { double :insurable_value }
    let(:insurance_rate)  { double :insurance_rate }
    let(:insurance_term)  { build :insurance_term }

    let(:result) { insurance_term.calculate_premium! insurable_value }

    before do
      allow(insurance_term).to receive(:insurance_rate).and_return insurance_rate
      allow(insurance_term).to receive(:premium).and_return premium
      allow(insurance_term).to receive(:overridden).and_return overridden
    end

    context 'when premium is calculated' do
      let(:premium)    { double :calculated_premium }
      let(:overridden) { false }

      before do
        allow(insurable_value).to receive(:*).with(insurance_rate).and_return premium
        allow(insurance_term).to receive(:update).with premium: premium
      end

      it { expect(result).to eq(premium) }
    end

    context 'when premium is manually overridden' do
      let(:premium)    { double :overridden_premium }
      let(:overridden) { true }

      it { expect(result).to eq(premium) }
    end
  end
end
