class AddEffectiveInterestRateToOptions < ActiveRecord::Migration
  def change
    add_column :options, :effective_interest_rate, :float
  end
end
