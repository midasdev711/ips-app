RSpec.shared_examples 'a taxable' do |taxable_name|
  let(:taxable) { send(taxable_name) }

  describe '#no_taxation?' do
    let(:status_indian) { false }
    let(:tax) { 'two' }

    before do
      allow(taxable).to receive(:status_indian).with(no_args)
        .and_return(status_indian)

      allow(taxable).to receive(:tax).with(no_args)
        .and_return(tax)
    end

    subject{ taxable.no_taxation? }

    context 'when status_indian' do
      let(:status_indian) { true }
      it { is_expected.to be_truthy }
    end

    context 'when no tax' do
      let(:tax) { 'no' }
      it { is_expected.to be_truthy }
    end

    context 'when no status indian and taxation enabled' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#tax_rate' do
    let(:no_taxation) { false }

    let(:gst)      { 0.05 }
    let(:pst)      { 0.06 }
    let(:province) { double :province, gst: gst, pst: pst }

    before do
      allow(taxable).to receive(:province).with(no_args)
        .and_return(province)

      allow(taxable).to receive(:no_taxation?).with(no_args)
        .and_return(no_taxation)

      allow(taxable).to receive(:tax).with(no_args)
        .and_return(tax)
    end

    subject{ taxable.tax_rate }

    context 'when no_taxation is true' do
      let(:tax) { 'one' }
      let(:no_taxation) { true }
      it { is_expected.to eql(0.0) }
    end

    context 'when it is one tax' do
      let(:tax) { 'one' }
      it { is_expected.to eql(gst) }
    end

    context 'when it is two tax' do
      let(:tax) { 'two' }
      it { is_expected.to eql(gst + pst) }
    end
  end
end
