require 'rails_helper'

RSpec.describe ProductAmount, '.calculate', type: :model do
  let(:deal)    { double :deal }
  let(:lender)  { double :lender, loan: 'foobar' }
  let(:product) { double :product }

  let(:strategy) { double :strategy }
  let(:strategy_result) { double :strategy_result }

  let(:product_amount) { double :product_amount }

  before do
    allow(described_class::STRATEGIES).to receive(:[]).with(lender.loan.to_sym).and_return(strategy)
    allow(described_class).to receive(:new).with(deal: deal, product: product).and_return(product_amount)
    allow(product_amount).to receive(:apply).with(strategy).and_return(strategy_result)
  end

  subject { described_class.calculate(deal: deal, lender: lender, product: product) }

  it { is_expected.to eql(strategy_result) }
end
