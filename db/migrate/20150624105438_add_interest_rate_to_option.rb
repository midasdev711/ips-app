class AddInterestRateToOption < ActiveRecord::Migration
  def change
    add_column :options, :interest_rate, :float
  end
end
