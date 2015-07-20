require 'spec_helper'

RSpec.describe FinancePayment, '.execute' do
  let(:result) { described_class.execute(amount, number_of_payments, effective_interest_rate) }
  let(:number_of_payments) { NumberOfPayments.execute(months, payment_frequency) }
  let(:effective_interest_rate) { EffectiveInterestRate.execute(nominal_interest_rate, payment_frequency) }
  let(:amount) { 4100647 } # $41,006.47
  let(:months) { 72 }

  context '2.99%' do
    let(:nominal_interest_rate) { 0.0299 }

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
