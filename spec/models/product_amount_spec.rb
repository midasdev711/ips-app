require 'rails_helper'

RSpec.describe ProductAmount, type: :model do
  let(:product_amount) { described_class.new(deal: double, product: double) }

  it_behaves_like 'a taxable', :product_amount
end
