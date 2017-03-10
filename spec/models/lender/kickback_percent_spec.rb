require 'rails_helper'

RSpec.describe Lender, type: :model do
  let(:kickback_rate) { 0.1567891.to_d }
  let(:lender) { build :lender, kickback_rate: kickback_rate }

  describe '#kickback_percent' do
    subject { lender.kickback_percent }

    it { is_expected.to eq (kickback_rate * 100).round(4) }
  end

  describe '#kickback_percent=' do
    let(:new_percent) { 23.456789 }
    let(:new_rate) { (new_percent.to_d / 100).round(4) }

    subject { lender.kickback_percent = new_percent }

    it { expect{subject}.to change{lender.kickback_rate}.from(kickback_rate).to(new_rate) }
  end
end
