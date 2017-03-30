require 'rails_helper'

RSpec.describe ProductAmount, '#province', type: :model do
  let(:deal) { double :deal, province: double }

  let(:product_amount) { described_class.new deal: deal, product: double }

  subject { product_amount.send :province }

  it { is_expected.to eql(deal.province) }
end
