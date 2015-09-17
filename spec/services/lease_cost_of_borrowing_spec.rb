require 'spec_helper'

RSpec.describe LeaseCostOfBorrowing, '.execute' do
  let(:result) { described_class.execute(amount, residual, payments_number, money_factor) }
  let(:payments_number) { PaymentsNumber.execute(months, payment_frequency) }
  let(:money_factor) { MoneyFactor.execute(nominal_interest_rate, payment_frequency) }
  let(:amount) { 3000000 } # $30,000.00
  let(:residual) { 1500000 } # $15,000.00
  let(:months) { 24 }

  context '5%' do
    let(:nominal_interest_rate) { 0.050 }

    context 'monthly' do
      let(:payment_frequency) { :monthly }
      it { expect(result).to eql(225000) } # $2,250.00
    end

    context 'biweekly' do
      let(:payment_frequency) { :biweekly }
      it { expect(result).to eql(225000) } # $2,250.00
    end
  end
end
