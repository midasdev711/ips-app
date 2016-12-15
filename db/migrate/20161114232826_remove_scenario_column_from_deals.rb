class RemoveScenarioColumnFromDeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :deals, :scenario, default: 1
  end
end
