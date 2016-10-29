require 'rails_helper'

RSpec.describe Calculator::Finance, '#calculate', type: :model do
  subject { calculator.send :calculate }

  let(:calculator) { described_class.new }

  let(:calculate_payment_result)           { double :calculate_payment_result }
  let(:calculate_cost_of_borrowing_result) { double :calculate_cost_of_borrowing_result }
  let(:calculate_balloon_result)           { double :calculate_balloon_result }

  before do
    allow(calculator).to receive(:calculate_payment).and_return(calculate_payment_result).once
    allow(calculator).to receive(:calculate_balloon).and_return(calculate_balloon_result).once
    allow(calculator).to receive(:calculate_cost_of_borrowing).and_return(calculate_cost_of_borrowing_result).once
  end

  it { is_expected.to be_truthy }

  it { expect{subject}.to change{calculator.payment}.to calculate_payment_result }
  it { expect{subject}.to change{calculator.balloon}.to calculate_balloon_result }
  it { expect{subject}.to change{calculator.cost_of_borrowing}.to calculate_cost_of_borrowing_result }
end
