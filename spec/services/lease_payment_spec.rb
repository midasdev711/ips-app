require 'spec_helper'

RSpec.describe LeasePayment, '.execute' do
  let(:result) { described_class.execute(amount, residual, number_of_payments, money_factor) }
  let(:number_of_payments) { NumberOfPayments.execute(months, payment_frequency) }
  let(:money_factor) { MoneyFactor.execute(nominal_interest_rate, payment_frequency) }
  let(:amount) { 3000000 } # $30,000.00
  let(:residual) { 1500000 } # $15,000.00
  let(:months) { 24 }

  context '5%' do
    let(:nominal_interest_rate) { 0.050 }

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
