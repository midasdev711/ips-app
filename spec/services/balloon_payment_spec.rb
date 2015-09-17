require 'spec_helper'

RSpec.describe BalloonPayment, '.execute' do
  let(:result) { described_class.execute(amount, term_payments_number, effective_interest_rate, payment) }
  let(:term_payments_number) { PaymentsNumber.execute(term, payment_frequency) }
  let(:payments_number) { PaymentsNumber.execute(amortization, payment_frequency) }
  let(:effective_interest_rate) { EffectiveInterestRate.execute(nominal_interest_rate, payment_frequency) }
  let(:payment) { FinancePayment.execute(amount, payments_number, effective_interest_rate) }

  let(:amount) { 10000000 } # $100,000.00
  let(:term) { 60 }
  let(:amortization) { 84 }

  context '0%' do
    let(:nominal_interest_rate) { 0 }

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
    let(:nominal_interest_rate) { 0.0499 }

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
