require 'capybara/rspec'
require 'rails_helper'

RSpec.configure do |config|
  config.include Warden::Test::Helpers

  config.after(:each) { Warden.test_reset! }
end
