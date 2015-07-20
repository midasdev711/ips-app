class RemoveInsuranceRatesLoanType < ActiveRecord::Migration
  def change
    remove_column :insurance_rates, :loan_type, :integer
  end
end
