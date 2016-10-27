require 'spec_helper'

RSpec.xdescribe LeasePayment, '.execute' do
  let(:result) { described_class.execute amount: amount, residual: residual, money_factor: money_factor, payments_number: payments_number }
  let(:payments_number) { PaymentsNumber.execute months: months, payment_frequency: payment_frequency }
  let(:money_factor) { MoneyFactor.execute interest_rate: interest_rate, payment_frequency: payment_frequency }
  let(:amount) { 3000000 } # $30,000.00
  let(:residual) { 1500000 } # $15,000.00
  let(:months) { 24 }

  context '5%' do
    let(:interest_rate) { 0.050 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(71875) } # $718.75
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(33173) } # $331.73
    end
  end
end
