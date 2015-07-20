class RenameTierBuydown < ActiveRecord::Migration
  def change
    rename_column :options, :tier_buydown, :buydown_tier
  end
end
