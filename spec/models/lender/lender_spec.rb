require 'rails_helper'

RSpec.describe Lender, type: :model do

  it { is_expected.to belong_to :deal }
  it { is_expected.to have_one(:product_list).through :deal }

  it { is_expected.to have_and_belong_to_many :products }
  it { is_expected.to have_many :insurance_terms }
  it { is_expected.to have_many(:insurance_policies).through :insurance_terms }

  it { is_expected.to validate_numericality_of(:amortization).allow_nil }
  it { is_expected.to validate_presence_of :bank }
  it { is_expected.to validate_presence_of :frequency }
  it { is_expected.to validate_presence_of :position }

  it { is_expected.to callback(:set_residual).after :validation }

  it { is_expected.to allow_value(0).for(:kickback_percent) }
  it { is_expected.to_not allow_value(-1).for(:kickback_percent) }

  let(:lender) { build :lender }

  describe '#buydown?' do
    subject { lender.buydown? }

    let(:tier) { double :tier, present?: true }

    before do
      allow(lender).to receive(:tier).and_return tier
    end

    context 'when tier selected' do
      let(:max_tier) { double :max_tier }

      before do
        allow(lender).to receive(:max_tier).and_return max_tier
        allow(tier).to   receive(:<=).with(max_tier).and_return enough
      end

      context 'and there is enough pocketbook profit for buy down' do
        let(:enough) { true }

        it { is_expected.to be_truthy }
      end

      context 'and there is not enough pocketbook profit for buy down' do
        let(:enough) { false }

        it { is_expected.to be_falsey }
      end
    end

    context 'when no tier selected' do
      let(:tier) { double :tier, present?: false }

      it { is_expected.to be_falsey }
    end
  end

  describe '#vehicle_amount' do
    let(:vehicle_amount) { double :vehicle_amount }

    before do
      allow(VehicleAmount).to receive(:calculate).with(lender).and_return(vehicle_amount)
    end

    subject{ lender.vehicle_amount }

    it { is_expected.to eql(vehicle_amount) }
  end

  describe '#products_amount' do
    subject { lender.products_amount }

    let(:product_one) { double :product }
    let(:product_two) { double :product }

    let(:money_class) { class_double('Money').as_stubbed_const }
    let(:money)       { double :money }

    let(:product_amount_class) { class_double('ProductAmount').as_stubbed_const }

    before do
      allow(lender).to receive(:products).and_return           [product_one]
      allow(lender).to receive(:invisible_products).and_return [product_two]

      allow(money_class).to receive(:new).with(0).and_return money
      allow(money).to receive(:+).with(money).and_return money

      allow(product_amount_class).to receive(:calculate).and_return money

      expect(product_amount_class).to receive(:calculate).with(deal: lender.deal, lender: lender, product: product_one).once
      expect(product_amount_class).to receive(:calculate).with(deal: lender.deal, lender: lender, product: product_two).once
    end

    it { is_expected.to eq money }
  end

  describe '#insurable_amount' do
    subject { lender.insurable_amount }

    let(:insurable_amount_class) { class_double('InsurableAmount').as_stubbed_const }
    let(:expected_amount) { double :expected_amount }

    before do
      expect(insurable_amount_class).to receive(:calculate).with(lender).and_return expected_amount
    end

    it { is_expected.to eq expected_amount }
  end

  describe '#max_tier' do
    subject { lender.max_tier }

    let(:money) { double :money, cents: cents }
    let(:cents) { double :cents }

    let(:tier) { double :tier }

    before do
      allow(lender).to receive(:pocketbook_profit).and_return money
      allow(cents).to receive(:/).with(1_000_00).and_return tier
    end

    it { is_expected.to eq tier }
  end

  describe '#reset_interest_rate' do
    subject { lender.send :reset_interest_rate }

    let(:min) { double :min }
    let(:max) { double :max }

    let(:rates) { [min, max] }

    before do
      allow(lender).to receive(:interest_rates_minmax).and_return rates
      allow(lender).to receive(:position).and_return position
    end

    context 'left-side lender' do
      let(:position) { 'left' }

      before do
        expect(lender).to receive(:interest_rate=).with max
      end

      it { is_expected.to be_truthy }
    end

    context 'right-side lender' do
      let(:position) { 'right' }

      before do
        expect(lender).to receive(:interest_rate=).with min
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '#interest_rates_minmax' do
    subject { lender.send :interest_rates_minmax }

    let(:interest_rates_collection) { double :interest_rates_collection }
    let(:interest_rates_minmax) { double :interest_rates_minmax }

    before do
      allow(lender).to receive(:interest_rates).and_return interest_rates_collection
      expect(interest_rates_collection).to receive(:minmax_by).and_return interest_rates_minmax
    end

    it { is_expected.to eq interest_rates_minmax }
  end

  describe '#reset!' do
    subject { lender.reset! }

    before do
      expect(lender).to receive :reset_interest_rate
      expect(lender).to receive :reset_insurance_terms
      expect(lender).to receive :reset_products
      expect(lender).to receive(:save!).and_return true
    end

    it { is_expected.to be_truthy }
  end

  describe '#reset_insurance_terms' do
    subject { lender.send :reset_insurance_terms }

    let(:insurance_terms) { double :insurance_terms }

    before do
      allow(lender).to receive(:position).and_return position
      allow(lender).to receive(:insurance_terms).and_return insurance_terms
    end

    context 'left-side lender' do
      let(:position) { 'left' }

      before do
        expect(insurance_terms).to receive(:destroy_all).once
      end

      it { is_expected.to be_truthy }
    end

    context 'right-side lender' do
      let(:position) { 'right' }
      let(:loan) { double :loan }
      let(:term) { double :term }
      let(:product_list) { double :product_list }

      let(:insurance_policies_collection) { double :insurance_policies_collection }
      let(:insurance_policies) { [insurance_policy] }
      let(:insurance_policy) { double :insurance_policy, category: insurance_policy_category }
      let(:insurance_policy_category) { double :insurance_policy_category }

      before do
        expect(insurance_terms).to receive(:destroy_all).once

        allow(lender).to receive(:loan).and_return loan
        allow(lender).to receive(:term).and_return term
        allow(lender).to receive(:product_list).and_return product_list

        allow(product_list).to receive(:insurance_policies).and_return insurance_policies_collection
        allow(insurance_policies_collection).to receive(:includes).with(:insurance_rates).and_return insurance_policies_collection
        allow(insurance_policies_collection).to receive(:where).with('insurance_rates.loan' => loan).and_return insurance_policies_collection
        allow(insurance_policies_collection).to receive(:references).with(:insurance_rates).and_return insurance_policies

        expect(insurance_terms).to receive(:create!).with(category: insurance_policy_category, insurance_policy: insurance_policy, term: term)
      end
    end
  end

  describe '#reset_products' do
    subject { lender.send :reset_products }

    let(:products) { double :products }
    let(:product_list) { double :product_list, products: products }

    before do
      allow(lender).to receive(:position).and_return position
    end

    context 'left-side lender' do
      let(:position) { 'left' }

      before do
        expect(lender).to receive(:products=).with([]).once
      end

      it { is_expected.to be_truthy }
    end

    context 'right-side lender' do
      let(:position) { 'right' }

      before do
        allow(lender).to receive(:product_list).and_return product_list
        allow(products).to receive(:visible).and_return products

        expect(lender).to receive(:products=).with(products).once
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '#calculator' do

    subject { lender.send :calculator }

    let(:frequency) { double :frequency }
    let(:rate)      { double :rate }
    let(:tax)       { double :tax }
    let(:term)      { double :term }

    before do
      allow(lender).to receive(:loan)
        .and_return loan
      allow(lender).to receive(:interest_rate).and_return rate
      allow(rate).to receive(:value).and_return rate
      allow(lender).to receive(:frequency)
        .and_return frequency
      allow(frequency).to receive(:to_sym)
        .and_return frequency
      allow(lender).to receive(:tax_rate)
        .and_return tax
      allow(lender).to receive(:term)
        .and_return term
    end

    context 'when loan is finance' do
      let(:loan) { 'finance' }
      let(:amortization) { double :amortization }

      let(:finance_calculator_klass) { class_double('Calculator::Finance').as_stubbed_const }
      let(:finance_calculator)       { double :finance_calculator }

      let(:expected_arguments) { { amortization: amortization, frequency: frequency, rate: rate, term: term } }

      before do
        allow(lender).to receive(:amortization)
          .and_return amortization

        allow(finance_calculator_klass).to receive(:new)
          .with(expected_arguments)
          .and_return finance_calculator
      end

      it { is_expected.to eq finance_calculator }
    end

    context 'when loan is lease' do
      let(:loan) { 'lease' }
      let(:residual) { double :residual }
      let(:lien) { double :lien }

      let(:lease_calculator_klass) { class_double('Calculator::Lease').as_stubbed_const }
      let(:lease_calculator)       { double :lease_calculator   }

      let(:expected_arguments) { { frequency: frequency, rate: rate, residual: residual, tax: tax, term: term, lien: lien } }

      before do
        allow(lender).to receive(:residual)
          .and_return residual

        allow(lender).to receive(:lien)
          .and_return lien

        allow(lease_calculator_klass).to receive(:new)
          .with(expected_arguments)
          .and_return lease_calculator
      end

      it { is_expected.to eq lease_calculator }
    end
  end

  describe '#invisible_products' do
    subject { lender.send :invisible_products }

    let(:product_list) { double :product_list, products: products }
    let(:products) { double :products, invisible: invisible_products }
    let(:invisible_products) { double :invisible_products }

    before do
      allow(lender).to receive(:product_list).and_return product_list
    end

    it { is_expected.to eq invisible_products }
  end

  describe '#pocketbook_profit' do
    subject { lender.send :pocketbook_profit }

    let(:product_collection) { double :product_collection }
    let(:money) { double :money }

    before do
      allow(money).to receive(:+).with(money).and_return money

      allow(product_collection).to receive(:pocketbook).and_return product_collection
      allow(product_collection).to receive(:profit).and_return money

      allow(lender).to receive(:invisible_products).and_return product_collection
      allow(lender).to receive(:products).and_return product_collection
    end

    it { is_expected.to eq money }
  end

  describe '#warnings?' do
    subject { lender.warnings? }

    before do
      allow(lender).to receive(:amount_warnings?).and_return amount_warnings
      allow(lender).to receive(:payment_warnings?).and_return payment_warnings
    end

    context 'no warnings' do
      let(:amount_warnings) { false }
      let(:payment_warnings) { false }

      it { is_expected.to be_falsey }
    end

    context 'amount warnings only' do
      let(:amount_warnings) { true }
      let(:payment_warnings) { false }

      it { is_expected.to be_truthy }
    end

    context 'payment warnings only' do
      let(:amount_warnings) { false }
      let(:payment_warnings) { true }

      it { is_expected.to be_truthy }
    end

    context 'both amount and payment warnings' do
      let(:amount_warnings) { true }
      let(:payment_warnings) { true }

      it { is_expected.to be_truthy }
    end
  end

  describe '#amount_warnings?' do
    subject { lender.send :amount_warnings? }

        let(:amount) { double :money }
    let(:max_amount) { double :money }

    let!(:warnings) { lender.warnings }

    before do
      allow(lender).to receive(:amount).and_return amount
      allow(lender).to receive(:max_amount).and_return max_amount

      allow(amount).to receive(:>).with(max_amount).and_return comparison_result
    end

    context 'amount is below maximum amount' do
      let(:comparison_result) { false }

      it { is_expected.to be_falsey }
      it { expect{subject}.not_to change{warnings.count}.from(0) }
    end

    context 'amount is above maximum amount' do
      let(:comparison_result) { true }

      it { is_expected.to be_truthy }
      it { expect{subject}.to change{warnings.count}.from(0).to(1) }
    end
  end

  describe '#payment_warnings?' do
    subject { lender.send :payment_warnings? }

        let(:payment) { double :money }
    let(:max_payment) { double :money }

    let(:deal) { double :deal, max_payment: max_payment }

    let!(:warnings) { lender.warnings }

    before do
      allow(lender).to receive(:payment).and_return payment
      allow(lender).to receive(:deal).and_return deal

      allow(payment).to receive(:>).with(max_payment).and_return comparison_result
    end

    context 'payment is below maximum payment' do
      let(:comparison_result) { false }

      it { is_expected.to be_falsey }
      it { expect{subject}.not_to change{warnings.count}.from(0) }
    end

    context 'payment is above maximum payment' do
      let(:comparison_result) { true }

      it { is_expected.to be_truthy }
      it { expect{subject}.to change{warnings.count}.from(0).to(1) }
    end
  end
end
