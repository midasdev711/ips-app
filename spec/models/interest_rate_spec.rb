require 'rails_helper'

RSpec.describe InterestRate, type: :model do
  it { is_expected.to belong_to :lender }

  let(:interest_rate) { build :interest_rate, value: value }

  let(:value)         { 0.0399 }
  let(:percent_value) { 3.99 }

  describe '#percent_value' do
    subject { interest_rate.percent_value }

    it { is_expected.to eq percent_value }
  end

  describe '#percent_value=' do
    let(:new_value)         { 0.0299 }
    let(:new_percent_value) { 2.99 }

    subject { interest_rate.percent_value = new_percent_value }

    it { expect{subject}.to change{interest_rate.value}.from(value).to(new_value) }
  end

  describe '#round!' do
    subject { interest_rate.round! }

    context 'when interest rate is 0%' do
      let(:value) { 0.0 }
      let(:rounded_value) { 0.0 }

      it { expect{subject}.not_to change{interest_rate.value} }
    end

    context 'when interest rate is 2%' do
      let(:value) { 0.02 }
      let(:rounded_value) { 0.0249 }

      it { expect{subject}.to change{interest_rate.value}.from(value).to(rounded_value) }
    end
  end
end
