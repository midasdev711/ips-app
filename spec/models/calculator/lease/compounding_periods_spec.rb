require 'rails_helper'

RSpec.describe Calculator::Lease, '#compounding_periods', type: :model do
  let(:term)       { 60 }
  let(:attributes) { { frequency: frequency, term: term } }
  let(:calculator) { described_class.new attributes }

  subject { calculator.send :compounding_periods }

  context 'when biweekly payments' do
    let(:frequency) { :biweekly }

    it { is_expected.to eq 130 }
  end

  context 'when monthly payments' do
    let(:frequency) { :monthly }

    it { is_expected.to eq 60 }
  end
end
