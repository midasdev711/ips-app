require 'rails_helper'

RSpec.describe Product, type: :model do

  it { is_expected.to belong_to :product_list }
  it { is_expected.to have_and_belong_to_many :lenders }

  it { is_expected.to validate_presence_of :name }

  describe 'collection methods' do
    let(:product_collection) { [product] }

    let(:money_class) { class_double('Money').as_stubbed_const }
    let(:money) { double :money }

    before do
      allow(described_class).to receive(:all).and_return product_collection
      allow(money_class).to receive(:new).and_return money
    end

    describe '.profit' do
      subject { described_class.profit }

      let(:product) { double :product, profit: money }

      before do
        allow(money).to receive(:+).with(money).and_return money
      end

      it { is_expected.to eq money }
    end
  end

  describe 'instance methods' do
    let(:product) { build :product }

    describe '#profit' do
      subject { product.profit }

      let(:money)   { double :money }

      before do
        allow(product).to receive(:retail_price).and_return money
        allow(product).to receive(:dealer_cost).and_return money

        allow(money).to receive(:-).with(money).and_return money
      end

      it { is_expected.to eq money }
    end
  end
end
