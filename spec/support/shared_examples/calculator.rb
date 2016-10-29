RSpec.shared_examples 'a calculator' do
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_inclusion_of(:frequency).in_array([:biweekly, :monthly]) }
  it { is_expected.to validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:term).is_greater_than(0).only_integer }

  subject { described_class.new attributes }

  [:amount, :frequency, :rate, :term, :cost_of_borrowing, :payment].each do |k|
    it { is_expected.to respond_to k }
  end

  context '.new' do
    it { is_expected.to be_a described_class }

    [:amount, :frequency, :rate, :term].each do |k|
      it { expect(subject.send k).to eq attributes[k] }
    end
  end
end
