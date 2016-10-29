require 'rails_helper'

RSpec.describe ProductList, type: :model do

  it { is_expected.to belong_to :listable }
  it { is_expected.to have_many(:products).autosave(true).dependent :destroy }
  it { is_expected.to have_many(:insurance_policies).autosave(true).dependent :destroy }

  it { is_expected.to validate_numericality_of(:car_reserved_profit_cents).is_greater_than_or_equal_to 0 }
  it { is_expected.to validate_numericality_of(:family_reserved_profit_cents).is_greater_than_or_equal_to 0 }
  it { is_expected.to validate_numericality_of(:insurance_profit_rate).is_greater_than_or_equal_to 0 }

  let(:product_list) { build :product_list, insurance_profit_rate: insurance_profit_rate }

  let(:insurance_profit_rate) { 0.5 }
  let(:insurance_profit)      { 50 }

  describe '#insurance_profit' do
    subject { product_list.insurance_profit }

    it { is_expected.to eq insurance_profit }
  end

  describe '#insurance_profit=' do
    let(:new_insurance_profit_rate) { 0.0299 }
    let(:new_insurance_profit)      { 2.99 }

    subject { product_list.insurance_profit = new_insurance_profit }

    it { expect{subject}.to change{product_list.insurance_profit_rate}.from(insurance_profit_rate).to(new_insurance_profit_rate) }
  end
end
