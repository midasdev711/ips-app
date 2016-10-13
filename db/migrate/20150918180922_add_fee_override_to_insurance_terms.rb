class AddFeeOverrideToInsuranceTerms < ActiveRecord::Migration
  def change
    add_column :insurance_terms, :fee_cents, :integer, default: 0
  end
end
