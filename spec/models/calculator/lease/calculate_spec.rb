require 'rails_helper'

RSpec.describe Calculator::Lease, '#calculate', type: :model do
  let(:calculator) { described_class.new }

  let(:calculate_payment_result)           { double :calculate_payment_result }
  let(:calculate_cost_of_borrowing_result) { double :calculate_cost_of_borrowing_result }

  before do
    allow(calculator).to receive(:calculate_payment).and_return(calculate_payment_result).once
    allow(calculator).to receive(:calculate_cost_of_borrowing).and_return(calculate_cost_of_borrowing_result).once

    calculator.send :calculate
  end

  it { is_expected.to be_truthy }

  it { expect(calculator.payment).to           eq calculate_payment_result }
  it { expect(calculator.cost_of_borrowing).to eq calculate_cost_of_borrowing_result }
end
