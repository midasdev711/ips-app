class AddResidualColumnToInsuranceRates < ActiveRecord::Migration[5.0]
  def change
  	add_column :insurance_rates, :residual, :boolean, default: false
  end
end
