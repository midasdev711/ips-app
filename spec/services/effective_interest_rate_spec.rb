require 'spec_helper'

RSpec.describe EffectiveInterestRate, '.execute' do
  let(:result) { described_class.execute(nominal_interest_rate, payment_frequency) }

  context '0%' do
    let(:nominal_interest_rate) { 0.0 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(0.0) }
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(0.0) }
    end
  end

  context '4.99%' do
    let(:nominal_interest_rate) { 0.0499 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(0.0041) }
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(0.0019) }
    end
  end
end
