require 'rails_helper'

RSpec.describe Calculator::Base, '#calculate!', type: :model do
  let(:calculator) { described_class.new }

  subject { calculator.calculate! }

  before do
    allow(calculator).to receive(:valid?).and_return valid
  end

  context 'when valid' do
    let(:valid) { true }

    before do
      expect(calculator).to receive(:calculate).and_return(true).once
    end

    it { is_expected.to be_truthy }
  end

  context 'when invalid' do
    let(:valid) { false }

    before do
      expect(calculator).not_to receive(:calculate)
    end

    it { is_expected.to be_falsey }
  end
end

RSpec.describe Calculator::Base, '#calculate', type: :model do
  let(:calculator) { described_class.new }

  subject { calculator.calculate }

  it { is_expected.to be_truthy }
end
