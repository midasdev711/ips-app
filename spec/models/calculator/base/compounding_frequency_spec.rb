require 'rails_helper'

RSpec.describe Calculator::Base, '#compounding_frequency', type: :model do
  let(:calculator) { described_class.new }

  let(:result) { calculator.send :compounding_frequency }

  before do
    allow(calculator).to receive(:frequency).and_return frequency
  end

  context 'when biweekly payments' do
    let(:frequency) { :biweekly }

    it { expect(result).to eq Calculator::FREQUENCY_BIWEEKLY }
  end

  context 'when monthly payments' do
    let(:frequency) { :monthly }

    it { expect(result).to eq Calculator::FREQUENCY_MONTHLY }
  end
end
