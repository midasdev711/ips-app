require 'rails_helper'

RSpec.describe '$30,000 deal', type: :calculation do

  let(:dealership) { create :dealership, province_id: 'SK' }
  let(:user) { create :user, dealership: dealership }

  let(:deal) { create :deal, user: user, tax: :two }

  before do
    lender, _ = deal.lenders
    lender.update bank: Faker::Company.name, loan_type: :finance, cash_price: Money.new(3000000), bank_reg_fee: Money.new(11774), interest_rates: [create(:interest_rate, value: '6.99')]

    @option = create :option, lender: lender, index: 1, loan_type: :finance, term: 84, payment_frequency: :biweekly, interest_rate: interest_rate
    @option.calculate
  end

  let(:cost_of_borrowing) { @option.cost_of_borrowing }
  let(:payment) { @option.categories.last.payment }

  [
    Example.new(6.99, 8804_14, 230_34),
    Example.new(4.74, 5828_44, 213_99),
    Example.new(3.99, 4865_66, 208_70),
    Example.new(3.49, 4232_30, 205_22),
    Example.new(2.99, 3606_22, 201_78),
    Example.new(2.49, 2987_42, 198_38),
    Example.new(1.99, 2374_08, 195_01),
    Example.new(1.49, 1768_02, 191_68),
    Example.new(0.99, 1167_42, 188_38),
    Example.new(0.49,  575_92, 185_13),
    Example.new(0.00,       0, 181_97)
  ].each do |e|
    context "at #{e.rate}%" do
      let(:interest_rate) { e.rate }

      it('Cost of Borrowing') { expect(cost_of_borrowing).to eq Money.new(e.cost_of_borrowing) }
      it('Payment') { expect(payment).to eq Money.new(e.payment) }
    end
  end
end
