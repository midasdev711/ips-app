require 'rails_helper'

RSpec.describe ProductAmount, '#status_indian', type: :model do
  let(:deal) { double :deal, status_indian: double }

  let(:product_amount) { described_class.new deal: deal, product: double }

  subject { product_amount.send :status_indian }

  it { is_expected.to eql(deal.status_indian) }
end
