require 'rails_helper'

RSpec.describe Lender, '#calculate!', type: :model do
  subject { lender.calculate! }

  let(:lender) { create :lender, frequency: 'monthly', loan: 'finance', position: position, term: 60, interest_rate: interest_rate, interest_rates: [interest_rate] }
  let(:interest_rate) { create :interest_rate, value: 0.05 }

  let(:vehicle_amount) { Money.new 20_000_00 }

  let(:product_categories) { [pocketbook, car, family] }

  before do
    allow(lender).to receive(:vehicle_amount).and_return vehicle_amount
    allow(lender).to receive(:product_categories).and_return product_categories
  end

  Struct.new 'ProductCategory', :name, :amount, :buy_down_amount, :profit, :interest_rate, :payment

  let(:pocketbook) { Struct::ProductCategory.new 'pocketbook', pocketbook_amount, pocketbook_buy_down_amount, pocketbook_profit, nil, nil }
  let(:car)        { Struct::ProductCategory.new 'car',               car_amount,        car_buy_down_amount,        car_profit, nil, nil }
  let(:family)     { Struct::ProductCategory.new 'family',         family_amount,     family_buy_down_amount,     family_profit, nil, nil }

  let(:pocketbook_amount)          { Money.new 0 }
  let(:pocketbook_buy_down_amount) { Money.new 0 }
  let(:pocketbook_profit)          { Money.new 0 }

  let(:car_amount)                 { Money.new 0 }
  let(:car_buy_down_amount)        { Money.new 0 }
  let(:car_profit)                 { Money.new 0 }

  let(:family_amount)              { Money.new 0 }
  let(:family_buy_down_amount)     { Money.new 0 }
  let(:family_profit)              { Money.new 0 }

  let(:products_amount)          { pocketbook_amount + car_amount + family_amount }
  let(:products_buy_down_amount) { pocketbook_buy_down_amount + car_buy_down_amount + family_buy_down_amount }
  let(:products_profit)          { pocketbook_profit + car_profit + family_profit }

  context 'left-hand side' do
    let(:position) { 'left' }

    context 'without products' do
      let(:expected_amount)            { vehicle_amount }
      let(:expected_payment)           { Money.new 377_42 }
      let(:expected_cost_of_borrowing) { Money.new 2_645_20 }

      it { expect{ subject }.to change{lender.amount}.to expected_amount }
      it { expect{ subject }.to change{lender.payment}.to expected_payment }
      it { expect{ subject }.to change{lender.cost_of_borrowing}.to expected_cost_of_borrowing }
    end

    context 'with products' do
      let(:pocketbook_amount) { Money.new 1_000_00 }
      let(:pocketbook_profit) { Money.new   500_00 }

      let(:car_amount)        { Money.new 1_000_00 }
      let(:car_profit)        { Money.new   500_00 }

      let(:family_amount)     { Money.new 1_000_00 }
      let(:family_profit)     { Money.new   500_00 }


      let(:expected_amount)            { vehicle_amount + products_amount }
      let(:expected_profit)            { products_profit }
      let(:expected_payment)           { Money.new 434_04 }
      let(:expected_cost_of_borrowing) { Money.new 3_042_40 }

      it { expect{ subject }.to change{lender.amount}.to expected_amount }
      it { expect{ subject }.to change{lender.profit}.to expected_profit }
      it { expect{ subject }.to change{lender.payment}.to expected_payment }
      it { expect{ subject }.to change{lender.cost_of_borrowing}.to expected_cost_of_borrowing }


      let(:expected_pocketbook_interest_rate) { interest_rate.value }
      let(:expected_pocketbook_payment)       { Money.new 396_30 }

      it { expect{ subject }.to change{pocketbook.interest_rate.try :value}.to expected_pocketbook_interest_rate }
      it { expect{ subject }.to change{pocketbook.payment}.to                  expected_pocketbook_payment }


      let(:expected_car_interest_rate)        { interest_rate.value }
      let(:expected_car_payment)              { Money.new 415_17 }

      it { expect{ subject }.to change{car.interest_rate.try :value}.to        expected_car_interest_rate }
      it { expect{ subject }.to change{car.payment}.to                         expected_car_payment }


      let(:expected_family_interest_rate)     { interest_rate.value }
      let(:expected_family_payment)           { Money.new 434_04 }

      it { expect{ subject }.to change{family.interest_rate.try :value}.to     expected_family_interest_rate }
      it { expect{ subject }.to change{family.payment}.to                      expected_family_payment }
    end
  end

  context 'right-hand side' do
    let(:position) { 'right' }

    before do
      allow(lender).to receive(:buydown?).and_return buydown
    end

    context 'buy down engaged' do
      let(:buydown) { true }

      context 'without products' do
        let(:expected_amount)            { vehicle_amount }
        let(:expected_payment)           { Money.new 377_42 }
        let(:expected_cost_of_borrowing) { Money.new 2_645_20 }

        it { expect{ subject }.to change{lender.amount}.to expected_amount }
        it { expect{ subject }.to change{lender.payment}.to expected_payment }
        it { expect{ subject }.to change{lender.cost_of_borrowing}.to expected_cost_of_borrowing }
      end

      context 'with products' do
        let(:pocketbook_amount)          { Money.new 1_000_00 }
        let(:pocketbook_buy_down_amount) { Money.new   250_00 }
        let(:pocketbook_profit)          { Money.new   250_00 }

        let(:car_amount)                 { Money.new 1_000_00 }
        let(:car_buy_down_amount)        { Money.new   250_00 }
        let(:car_profit)                 { Money.new   500_00 }

        let(:family_amount)              { Money.new 1_000_00 }
        let(:family_buy_down_amount)     { Money.new   250_00 }
        let(:family_profit)              { Money.new   500_00 }


        let(:expected_amount)            { vehicle_amount + products_amount }
        let(:expected_profit)            { products_profit - products_buy_down_amount }
        let(:expected_payment)           { Money.new 421_20 }
        let(:expected_cost_of_borrowing) { Money.new 2_272_00 }

        it { expect{ subject }.to change{lender.amount}.to expected_amount }
        it { expect{ subject }.to change{lender.profit}.to expected_profit }
        it { expect{ subject }.to change{lender.payment}.to expected_payment }
        it { expect{ subject }.to change{lender.cost_of_borrowing}.to expected_cost_of_borrowing }


        let(:expected_pocketbook_interest_rate) { 0.0455 }
        let(:expected_pocketbook_payment)       { Money.new 391_98 }

        it { expect{ subject }.to change{pocketbook.interest_rate.try :value}.to expected_pocketbook_interest_rate }
        it { expect{ subject }.to change{pocketbook.payment}.to                  expected_pocketbook_payment }


        let(:expected_car_interest_rate)        { 0.0414 }
        let(:expected_car_payment)              { Money.new 406_55 }

        it { expect{ subject }.to change{car.interest_rate.try :value}.to        expected_car_interest_rate }
        it { expect{ subject }.to change{car.payment}.to                         expected_car_payment }


        let(:expected_family_interest_rate)     { 0.0377 }
        let(:expected_family_payment)           { Money.new 421_20 }

        it { expect{ subject }.to change{family.interest_rate.try :value}.to     expected_family_interest_rate }
        it { expect{ subject }.to change{family.payment}.to                      expected_family_payment }

        context 'interest rate rounding engaged' do
          before do
            allow(lender).to receive(:rounding).and_return true
          end

          let(:expected_payment)           { Money.new 423_48 }
          let(:expected_cost_of_borrowing) { Money.new 2_408_80 }

          it { expect{ subject }.to change{lender.amount}.to expected_amount }
          it { expect{ subject }.to change{lender.profit}.to expected_profit }
          it { expect{ subject }.to change{lender.payment}.to expected_payment }
          it { expect{ subject }.to change{lender.cost_of_borrowing}.to expected_cost_of_borrowing }


          let(:expected_pocketbook_interest_rate) { 0.0499 }
          let(:expected_pocketbook_payment)       { Money.new 396_20 }

          it { expect{ subject }.to change{pocketbook.interest_rate.try :value}.to expected_pocketbook_interest_rate }
          it { expect{ subject }.to change{pocketbook.payment}.to                  expected_pocketbook_payment }


          let(:expected_car_interest_rate)        { 0.0449 }
          let(:expected_car_payment)              { Money.new 410_05 }

          it { expect{ subject }.to change{car.interest_rate.try :value}.to        expected_car_interest_rate }
          it { expect{ subject }.to change{car.payment}.to                         expected_car_payment }


          let(:expected_family_interest_rate)     { 0.0399 }
          let(:expected_family_payment)           { Money.new 423_48 }

          it { expect{ subject }.to change{family.interest_rate.try :value}.to     expected_family_interest_rate }
          it { expect{ subject }.to change{family.payment}.to                      expected_family_payment }
        end
      end
    end

    xcontext 'buy down not engaged' do
      let(:buydown) { false }
    end
  end
end
