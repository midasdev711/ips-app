MoneyRails.configure do |config|
  config.default_currency = :cad
  config.default_format = {
    no_cents: true
  }
end
