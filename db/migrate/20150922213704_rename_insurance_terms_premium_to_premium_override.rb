class RenameInsuranceTermsPremiumToPremiumOverride < ActiveRecord::Migration
  def change
    rename_column :insurance_terms, :premium_cents, :premium_override_cents
  end
end
