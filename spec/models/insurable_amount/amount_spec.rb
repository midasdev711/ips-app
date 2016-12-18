require 'rails_helper'

RSpec.describe InsurableAmount, '#amount', type: :model do

  let(:products_amount) { Money.new 1_00 }
  let(:vehicle_amount) { Money.new 1_00 }

  let(:lender) do
    double :lender,
      build_calculator: calculator,
      vehicle_amount: vehicle_amount,
      products_amount: products_amount
  end

  let(:amount) { products_amount + vehicle_amount }
  let(:cost_of_borrowing) { Money.new 1_00 }

  let(:calculator) { double :calculator, amount: amount, cost_of_borrowing: cost_of_borrowing }

  let(:insurable_amount) { described_class.new(lender) }

  before do
    expect(calculator).to receive(:amount=).with(amount)
    expect(calculator).to receive(:calculate!)
  end

  subject{ insurable_amount.amount }

  it { is_expected.to eq(products_amount + vehicle_amount + cost_of_borrowing) }
end
