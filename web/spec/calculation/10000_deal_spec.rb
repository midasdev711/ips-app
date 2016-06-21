require 'rails_helper'

RSpec.describe '$10,000 deal', type: :calculation do

  let(:dealership) { create :dealership, province_id: 'SK' }
  let(:user) { create :user, dealership: dealership }

  let(:deal) { create :deal, user: user, tax: :two }

  before do
    lender, _ = deal.lenders
    lender.update bank: Faker::Company.name, loan_type: :finance, cash_price: Money.new(2000000), bank_reg_fee: Money.new(11774), interest_rates: [create(:interest_rate, value: '6.99')]

    @option = create :option, lender: lender, index: 1, loan_type: :finance, term: 84, payment_frequency: :biweekly, interest_rate: interest_rate
    @option.calculate
  end

  let(:cost_of_borrowing) { @option.cost_of_borrowing }

  Example = Struct.new(:rate, :cost_of_borrowing)
  [
    Example.new(6.99, 5881_14),
    Example.new(4.74, 3891_88),
    Example.new(3.99, 3249_42),
    Example.new(3.49, 2827_18),
    Example.new(2.99, 2408_58),
    Example.new(2.49, 1995_44),
    Example.new(1.99, 1585_94),
    Example.new(1.49, 1180_08),
    Example.new(0.99,  779_68),
    Example.new(0.49,  384_74),
    Example.new(0.00,       0)
  ].each do |e|
    context "at #{e.rate}%" do
      let(:interest_rate) { e.rate }

      it { expect(cost_of_borrowing).to eq Money.new(e.cost_of_borrowing) }
    end
  end
end
