require 'rails_helper'

RSpec.describe Calculator::Base, type: :model do
  let(:attributes) { attributes_for :calculator }

  it_behaves_like 'a calculator'
end
