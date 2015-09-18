class PremiumOverrideDefault < ActiveRecord::Migration
  def change
    change_column_default :insurance_terms, :premium_override_cents, nil
  end
end
