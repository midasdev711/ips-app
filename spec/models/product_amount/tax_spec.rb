require 'rails_helper'

RSpec.describe ProductAmount, '#tax', type: :model do
  let(:product) { double :product, tax: double }

  let(:product_amount) { described_class.new product: product, deal: double }

  subject { product_amount.send :tax }

  it { is_expected.to eql(product.tax) }
end
