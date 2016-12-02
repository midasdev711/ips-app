require 'rails_helper'

RSpec.describe Calculator::Base, '#compounding_periods', type: :model do
  let(:attributes) { { frequency: frequency } }
  let(:calculator) { described_class.new attributes }

  subject { calculator.send :compounding_periods, months }

  context 'when biweekly payments' do
    let(:frequency) { :biweekly }

    context 'for 36 months' do
      let(:months) { 36 } # 3 years

      it { is_expected.to eq 78 }
    end

    context 'for 60 months' do
      let(:months) { 60 } # 5 years

      it { is_expected.to eq 130 }
    end
  end

  context 'when monthly payments' do
    let(:frequency) { :monthly }

    context 'for 36 months' do
      let(:months) { 36 } # 3 years

      it { is_expected.to eq 36 }
    end

    context 'for 60 months' do
      let(:months) { 60 } # 5 years

      it { is_expected.to eq 60 }
    end
  end

  context 'when semimonthly payments' do
    let(:frequency) { :semimonthly }

    context 'for 36 months' do
      let(:months) { 36 } # 3 years

      it { is_expected.to eq 72 }
    end

    context 'for 60 months' do
      let(:months) { 60 } # 5 years

      it { is_expected.to eq 120 }
    end
  end

  context 'when weekly payments' do
    let(:frequency) { :weekly }

    context 'for 36 months' do
      let(:months) { 36 } # 3 years

      it { is_expected.to eq 156 }
    end

    context 'for 60 months' do
      let(:months) { 60 } # 5 years

      it { is_expected.to eq 260 }
    end
  end
end
