require 'spec_helper'

RSpec.describe FinanceCostOfBorrowing, '.execute' do
  let(:result) { described_class.execute amount: amount, payment: payment, payments_number: payments_number }
  let(:payments_number) { PaymentsNumber.execute months: months, payment_frequency: payment_frequency }
  let(:effective_interest_rate) { EffectiveInterestRate.execute interest_rate: interest_rate, payment_frequency: payment_frequency }
  let(:payment) { FinancePayment.execute amount: amount, interest_rate: effective_interest_rate, payments_number: payments_number }
  let(:amount) { 4100647 } # $41,006.47
  let(:months) { 72 }

  context '2.99%' do
    let(:interest_rate) { 0.0299 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(385241) } # $3,852.41
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(364073) } # $3,640.73
    end
  end
end
