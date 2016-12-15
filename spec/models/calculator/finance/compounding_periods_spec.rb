require 'rails_helper'

RSpec.describe Calculator::Finance, '#compounding_periods', type: :model do
  let(:amortization) { nil }
  let(:term)         { 60 }
  let(:attributes) { { amortization: amortization, frequency: frequency, term: term } }
  let(:calculator) { described_class.new attributes }

  subject { calculator.send :compounding_periods }

  context 'when biweekly payments' do
    let(:frequency) { :biweekly }

    it { is_expected.to eq 130 }

    context 'and amortization presents' do
      let(:amortization) { 72 }

      it { is_expected.to eq 156 }
    end

    context 'and months given' do
      let(:months) { 48 }

      subject { calculator.send :compounding_periods, months }

      it { is_expected.to eq 104 }
    end
  end

  context 'when monthly payments' do
    let(:frequency) { :monthly }

    it { is_expected.to eq 60 }

    context 'and amortization presents' do
      let(:amortization) { 84 }

      it { is_expected.to eq 84 }
    end

    context 'and months given' do
      let(:months) { 96 }

      subject { calculator.send :compounding_periods, months }

      it { is_expected.to eq 96 }
    end
  end
end
