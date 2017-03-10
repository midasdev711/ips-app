require 'rails_helper'

RSpec.describe ProductAmount, '#tax_rate', type: :model do
  let(:deal)    { double :deal, province: province, status_indian: status_indian }
  let(:product) { double :product, tax: tax }

  let(:province) { double :province, gst: gst, pst: pst }
  let(:gst)      { 0.05 }
  let(:pst)      { 0.07 }

  let(:status_indian) { false }
  let(:tax)           { 'two' }

  let(:product_amount) { described_class.new deal: deal, product: product }

  let(:no_tax)  { 0.0 }
  let(:one_tax) { gst }
  let(:two_tax) { gst + pst }

  subject { product_amount.send :tax_rate }

  context 'status indian' do
    let(:status_indian) { true }

    it { is_expected.to eq no_tax }
  end

  context 'no tax' do
    let(:tax) { 'no' }

    it { is_expected.to eq no_tax }
  end

  context 'one tax' do
    let(:tax) { 'one' }

    it { is_expected.to eq one_tax }
  end

  context 'two tax' do
    it { is_expected.to eq two_tax }
  end
end
