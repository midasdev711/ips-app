require 'rails_helper'

RSpec.describe FinanceCostOfBorrowing, type: :model do

  describe '#execute' do
    let(:opts)   { double :opts, values_at: [amount, payment, payments_number] }
    let(:result) { described_class.execute opts }

    let(:amount)          { double :amount }
    let(:payment)         { double :payment }
    let(:payments_number) { double :payments_number }

    let(:total)             { double :total }
    let(:cost_of_borrowing) { double :cost_of_borrowing }

    before do
      allow(payment).to receive(:*).with(payments_number).and_return total
      allow(total).to receive(:-).with(amount).and_return cost_of_borrowing
    end

    it { expect(result).to eq(cost_of_borrowing) }
  end
end
