class RenameInsuranceFeeToInsurancePremium < ActiveRecord::Migration
  def change
    rename_column :insurance_terms, :fee_cents, :premium_cents
  end
end
