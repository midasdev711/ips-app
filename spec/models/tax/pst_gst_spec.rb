require 'rails_helper'

RSpec.describe Tax, type: :model do
  let(:tax) { described_class.new(double :lender) }

  describe '#pst' do
    let(:pst) { double :pst }

    before do
      allow(tax).to receive(:calculate).with(:pst)
        .and_return(pst)
    end

    subject{ tax.pst }

    it { is_expected.to eql(pst) }
  end

  describe '#pst' do
    let(:gst) { double :gst }

    before do
      allow(tax).to receive(:calculate).with(:gst)
        .and_return(gst)
    end

    subject{ tax.gst }

    it { is_expected.to eql(gst) }
  end
end
