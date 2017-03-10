require 'rails_helper'

RSpec.describe ProductAmount, '#tax', type: :model do
  let(:amount)   { Money.new 1000 }
  let(:tax_rate) { 0.12 }

  let(:deal)    { double :deal }
  let(:product) { double :product }

  let(:product_amount) { described_class.new deal: deal, product: product }

  before do
    allow(product_amount).to receive(:amount).and_return(amount)
    allow(product_amount).to receive(:tax_rate).and_return(tax_rate)
  end

  subject { product_amount.send :tax }

  it { is_expected.to eq(amount * tax_rate) }
end
