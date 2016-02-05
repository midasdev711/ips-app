require 'rails_helper'

RSpec.describe DealershipsController, type: :controller do

  describe '#create' do
    let(:admin) { double :admin, admin?: true, financial_manager?: false }
    let(:dealership) { spy :dealership }
    let(:params) { attributes_for :dealership }

    before do
      allow_any_instance_of(DealershipsController).to receive(:resource_params).and_return params

      expect(admin).to receive(:add_dealership).with(params).once.and_return dealership
    end

    def send_request
      sign_in admin
      post :create, params
    end

    subject { send_request; response }

    context 'with valid params' do

      before do
        allow(dealership).to receive(:persisted?).and_return true
      end

      it { is_expected.to redirect_to root_path }
    end

    context 'with invalid params' do

      before do
        allow(dealership).to receive(:persisted?).and_return false
      end

      it { is_expected.to be_success }
    end
  end
end
