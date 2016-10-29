require 'rails_helper'

RSpec.describe Calculator::Finance, type: :model do
  let(:attributes) { attributes_for :finance }

  it_behaves_like 'a calculator'

  subject { described_class.new attributes }

  it { is_expected.to validate_numericality_of(:amortization).is_greater_than(subject.term).only_integer.allow_nil }

  [:amortization, :balloon].each do |k|
    it { is_expected.to respond_to k }
  end

  context '.new' do
    [:amortization].each do |k|
      it { expect(subject.send k).to eq attributes[k] }
    end
  end
end
