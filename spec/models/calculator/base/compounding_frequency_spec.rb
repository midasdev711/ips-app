require 'rails_helper'

RSpec.describe Calculator::Base, '#compounding_frequency', type: :model do
  let(:calculator) { described_class.new }

  let(:result) { calculator.send :compounding_frequency }

  before do
    allow(calculator).to receive(:frequency).and_return frequency
  end

  context 'when biweekly payments' do
    let(:frequency) { :biweekly }

    it { expect(result).to eq Calculator::FREQUENCIES[:biweekly] }
  end

  context 'when monthly payments' do
    let(:frequency) { :monthly }

    it { expect(result).to eq Calculator::FREQUENCIES[:monthly] }
  end

  context 'when semimonthly payments' do
    let(:frequency) { :semimonthly }

    it { expect(result).to eq Calculator::FREQUENCIES[:semimonthly] }
  end

  context 'when weekly payments' do
    let(:frequency) { :weekly }

    it { expect(result).to eq Calculator::FREQUENCIES[:weekly] }
  end
end
