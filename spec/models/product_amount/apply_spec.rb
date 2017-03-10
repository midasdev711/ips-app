require 'rails_helper'

RSpec.describe ProductAmount, '#apply', type: :model do
  let(:deal)    { double :deal }
  let(:product) { double :product }

  let(:product_amount) { described_class.new deal: deal, product: product }

  let(:strategy) { lambda{ 'oops' } }
  let(:strategy_result) { double :strategy_result }

  before do
    allow(product_amount).to receive(:instance_eval).with(no_args, &strategy).and_return(strategy_result)
  end

  subject { product_amount.apply strategy }

  it { is_expected.to eq strategy_result }
end
