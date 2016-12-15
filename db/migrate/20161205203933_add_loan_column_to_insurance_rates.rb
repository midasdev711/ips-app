class AddLoanColumnToInsuranceRates < ActiveRecord::Migration[5.0]
  def change
  	add_column :insurance_rates, :loan, :integer
  end
end
