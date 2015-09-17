require 'spec_helper'

RSpec.describe FinanceCostOfBorrowing, '.execute' do
  let(:result) { described_class.execute(amount, payments_number, payment) }
  let(:payments_number) { PaymentsNumber.execute(months, payment_frequency) }
  let(:effective_interest_rate) { EffectiveInterestRate.execute(nominal_interest_rate, payment_frequency) }
  let(:payment) { FinancePayment.execute(amount, payments_number, effective_interest_rate) }
  let(:amount) { 4100647 } # $41,006.47
  let(:months) { 72 }

  context '2.99%' do
    let(:nominal_interest_rate) { 0.0299 }

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
