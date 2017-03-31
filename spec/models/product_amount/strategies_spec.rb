require 'rails_helper'

RSpec.describe ProductAmount, 'strategies', type: :model do
  let(:amount) { Money.new 1000 }
  let(:tax_amount)    { Money.new 120  }

  let(:product_amount) { double :product_amount, amount: amount, tax_amount: tax_amount }

  subject { product_amount.instance_eval(&strategy) }

  context 'finance' do
    let(:strategy) { ProductAmount::STRATEGIES[:finance] }

    it { is_expected.to eq(amount + tax_amount) }
  end

  context 'lease' do
    let(:strategy) { ProductAmount::STRATEGIES[:lease] }

    it { is_expected.to eq(amount) }
  end
end
