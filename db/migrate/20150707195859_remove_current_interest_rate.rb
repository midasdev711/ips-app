class RemoveCurrentInterestRate < ActiveRecord::Migration
  def change
    remove_column :options, :current_interest_rate
  end
end
