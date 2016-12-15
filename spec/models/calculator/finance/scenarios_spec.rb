require 'rails_helper'

RSpec.describe Calculator::Finance, type: :calculation do
  subject { described_class.new attributes }

  let(:attributes) { attributes_for :finance, amortization: amortization, amount: amount, frequency: frequency, rate: rate, term: term }

  FinanceScenario = Struct.new :amount, :frequency, :rate, :amortization, :term, :cost_of_borrowing, :payment, :balloon

  [
    FinanceScenario.new(50_000_00, :monthly,  0.000, nil, 36,        0, 1_388_89,         0),
    FinanceScenario.new(50_000_00, :monthly,  0.050, nil, 36, 3_947_44, 1_498_54,         0),
    FinanceScenario.new(50_000_00, :monthly,  0.075, nil, 36, 5_991_16, 1_555_31,         0),

    FinanceScenario.new(50_000_00, :biweekly, 0.000, nil, 48,        0,   480_77,         0),
    FinanceScenario.new(50_000_00, :biweekly, 0.050, nil, 48, 5_214_64,   530_91,         0),
    FinanceScenario.new(50_000_00, :biweekly, 0.075, nil, 48, 7_945_68,   557_17,         0),

    FinanceScenario.new(50_000_00, :monthly,  0.000,  48, 36,        0, 1_041_67, 12_499_88),
    FinanceScenario.new(50_000_00, :monthly,  0.050,  48, 36, 5_270_08, 1_151_46, 13_450_41),
    FinanceScenario.new(50_000_00, :monthly,  0.075,  48, 36, 8_029_60, 1_208_95, 13_933_91),
  ].each do |s|
    context s.to_s do
      let(:amount) { Money.new s.amount }
      let(:frequency) { s.frequency }
      let(:rate) { s.rate }
      let(:amortization) { s.amortization }
      let(:term) { s.term }

      let(:expected_payment)           { Money.new s.payment }
      let(:expected_balloon)           { Money.new s.balloon }
      let(:expected_cost_of_borrowing) { Money.new s.cost_of_borrowing }

      before do
        subject.calculate!
      end

      it { expect(subject.payment).to           eq expected_payment }
      it { expect(subject.balloon).to           eq expected_balloon }
      it { expect(subject.cost_of_borrowing).to eq expected_cost_of_borrowing }
    end
  end
end
