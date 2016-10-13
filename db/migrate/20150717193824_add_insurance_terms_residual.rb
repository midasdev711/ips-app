class AddInsuranceTermsResidual < ActiveRecord::Migration
  def change
    add_column :insurance_terms, :residual, :boolean
  end
end
