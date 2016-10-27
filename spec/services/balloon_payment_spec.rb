require 'spec_helper'

RSpec.xdescribe BalloonPayment, '.execute' do
  let(:result) { described_class.execute amount: amount, interest_rate: effective_interest_rate, payment: payment, payments_number: term_payments_number }
  let(:term_payments_number) { PaymentsNumber.execute months: term, payment_frequency: payment_frequency }
  let(:payments_number) { PaymentsNumber.execute months: amortization, payment_frequency: payment_frequency }
  let(:effective_interest_rate) { EffectiveInterestRate.execute interest_rate: interest_rate, payment_frequency: payment_frequency }
  let(:payment) { FinancePayment.execute amount: amount, interest_rate: effective_interest_rate, payments_number: payments_number }

  let(:amount) { 10000000 } # $100,000.00
  let(:term) { 60 }
  let(:amortization) { 84 }

  context '0%' do
    let(:interest_rate) { 0 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(2857180) } # $28,571.80
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(2857150) } # $28,571.50
    end
  end

  context '4.99%' do
    let(:interest_rate) { 0.0499 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(3215766) } # $32,157.66
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(3217645) } # #32,176.45
    end
  end
end
