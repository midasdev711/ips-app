class AddInsuranceTermsOverriden < ActiveRecord::Migration
  def change
    add_column :insurance_terms, :overridden, :boolean, default: false
  end
end
