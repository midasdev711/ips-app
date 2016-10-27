require 'spec_helper'

RSpec.xdescribe FinancePayment, '.execute' do
  let(:result) { described_class.execute amount: amount, interest_rate: effective_interest_rate, payments_number: payments_number }
  let(:payments_number) { PaymentsNumber.execute months: months, payment_frequency: payment_frequency }
  let(:effective_interest_rate) { EffectiveInterestRate.execute interest_rate: interest_rate, payment_frequency: payment_frequency }
  let(:amount) { 4100647 } # $41,006.47
  let(:months) { 72 }

  context '2.99%' do
    let(:interest_rate) { 0.0299 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(62304) } # $623.04
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(28620) } # $286.20
    end
  end
end
