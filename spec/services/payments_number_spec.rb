require 'spec_helper'

RSpec.describe PaymentsNumber, '.execute' do
  let(:result) { described_class.execute months: months, payment_frequency: payment_frequency }

  context '1 year' do
    let(:months) { 12 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(12) }
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(26) }
    end
  end

  context '5 years' do
    let(:months) { 60 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(60) }
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(130) }
    end
  end
end
