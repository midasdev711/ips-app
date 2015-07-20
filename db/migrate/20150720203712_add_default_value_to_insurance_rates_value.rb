class AddDefaultValueToInsuranceRatesValue < ActiveRecord::Migration
  def change
    change_column_default :insurance_rates, :value, 0.0
  end
end
