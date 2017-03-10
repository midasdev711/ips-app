require 'rails_helper'

RSpec.describe ProductAmount, '#amount', type: :model do
  let(:deal) { double :deal }
  let(:product) { double :product, retail_price: retail_price }

  let(:retail_price) { Money.new 500 }

  let(:product_amount) { described_class.new deal: deal, product: product }

  subject { product_amount.send :amount }

  it { is_expected.to eq retail_price }
end
