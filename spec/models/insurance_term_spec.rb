require 'rails_helper'

RSpec.describe InsuranceTerm, type: :model do

  describe '#fee' do
    let(:insurable_value) { double :insurable_value }
    let(:insurance_rate)  { double :insurance_rate }
    let(:fee)             { double :fee }
    let(:fee_override)    { double :fee_override }

    let(:insurance_term) { build :insurance_term }

    let(:result) { insurance_term.fee insurable_value }

    before do
      allow(insurance_term).to receive(:fee_override).and_return fee_override
      allow(insurance_term).to receive(:insurance_rate).and_return insurance_rate
    end

    context 'when insurance premium was calculated' do
      before do
        allow(fee_override).to receive(:zero?).and_return true
        allow(insurable_value).to receive(:*).with(insurance_rate).and_return fee
      end

      it { expect(result).to eq(fee) }
    end

    context 'when insurance premium was manually overriden' do
      before do
        allow(fee_override).to receive(:zero?).and_return false
      end

      it { expect(result).to eq(fee_override) }
    end
  end
end
