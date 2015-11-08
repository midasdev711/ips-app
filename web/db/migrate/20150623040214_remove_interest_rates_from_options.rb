class RemoveInterestRatesFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :interest_rate
    remove_column :options, :pocketbook_interest_rate
    remove_column :options, :car_interest_rate
    remove_column :options, :family_interest_rate
  end
end
