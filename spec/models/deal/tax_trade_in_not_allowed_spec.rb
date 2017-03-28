require 'rails_helper'

RSpec.describe Deal, '#tax_trade_in_not_allowed?', type: :model do
  let(:deal) { build :deal }

  before do
    allow(deal).to receive(:"#{type}_trade_in_allowance?").with(no_args)
      .and_return(trade_in_allowance)
  end

  subject{ deal.tax_trade_in_not_allowed?(type) }

  context 'for pst' do
    let(:type) { :pst }

    context 'when trade_in_allowance is true' do
      let(:trade_in_allowance) { true }
      it { is_expected.to be_falsey }
    end

    context 'when trade_in_allowance is false' do
      let(:trade_in_allowance) { false }
      it { is_expected.to be_truthy }
    end
  end

  context 'for gst' do
    let(:type) { :gst }

    context 'when trade_in_allowance is true' do
      let(:trade_in_allowance) { true }
      it { is_expected.to be_falsey }
    end

    context 'when trade_in_allowance is false' do
      let(:trade_in_allowance) { false }
      it { is_expected.to be_truthy }
    end
  end
end
