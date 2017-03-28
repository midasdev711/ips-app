require 'rails_helper'

RSpec.describe Deal, type: :model do
  let(:deal) { build :deal }

  it_behaves_like 'a taxable', :deal
end
