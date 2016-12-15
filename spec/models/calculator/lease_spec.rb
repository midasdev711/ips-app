require 'rails_helper'

RSpec.describe Calculator::Lease, type: :model do
  let(:attributes) { attributes_for :lease }

  it_behaves_like 'a calculator'

  subject { described_class.new attributes }

  it { is_expected.to validate_presence_of(:residual) }
  it { is_expected.to validate_presence_of(:tax) }

  it { is_expected.to validate_numericality_of(:tax).is_greater_than_or_equal_to(0) }

  [:residual, :tax].each do |k|
    it { is_expected.to respond_to k }
  end

  context '.new' do
    [:residual, :tax].each do |k|
      it { expect(subject.send k).to eq attributes[k] }
    end
  end
end
