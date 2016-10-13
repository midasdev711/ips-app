class RemoveInsuranceTermsResidual < ActiveRecord::Migration
  def change
    remove_column :insurance_terms, :residual
  end
end
