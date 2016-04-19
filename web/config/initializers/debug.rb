Rails.application.configure do
  config.debug = ENV['DEBUG'] == 'true'
end
