class RenameEffectiveInterestRateToCurrentInterestRate < ActiveRecord::Migration
  def change
    rename_column :options, :effective_interest_rate, :current_interest_rate
  end
end
