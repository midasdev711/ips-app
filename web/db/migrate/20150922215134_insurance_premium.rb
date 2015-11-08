class InsurancePremium < ActiveRecord::Migration
  def change
    rename_column :insurance_terms, :premium_override_cents, :premium_cents
    change_column_default :insurance_terms, :premium_cents, 0
  end
end
