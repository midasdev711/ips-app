require 'rails_helper'

RSpec.describe Calculator::Base, '#effective_rate', type: :model do
  let(:rate)                  { double :rate }
  let(:compounding_frequency) { double :compounding_frequency }
  let(:effective_rate)        { double :effective_rate }

  let(:calculator) { described_class.new }

  let(:result) { calculator.send :effective_rate }

  before do
    allow(calculator).to receive(:rate).and_return rate
    allow(calculator).to receive(:compounding_frequency).and_return compounding_frequency
    allow(rate).to receive(:/).with(compounding_frequency).and_return effective_rate
  end

  it { expect(result).to eq effective_rate }
end
