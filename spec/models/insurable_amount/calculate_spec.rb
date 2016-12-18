require 'rails_helper'

RSpec.describe InsurableAmount, '.calculate', type: :model do
  let(:lender) { double :lender, loan: 'foobar' }
  let(:insurable_amount) { double :insurable_amount }

  let(:expected_amount) { double :expected_amount }

  before do
    allow(described_class).to receive(:new).with(lender).and_return(insurable_amount)
    allow(insurable_amount).to receive(:amount).and_return(expected_amount)
  end

  subject { described_class.calculate(lender) }

  it { is_expected.to eq expected_amount }
end
