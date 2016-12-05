class AddResidualColumnToInsuranceTerms < ActiveRecord::Migration[5.0]
  def change
  	add_column :insurance_terms, :residual, :boolean, default: false
  end
end
