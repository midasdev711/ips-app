class RemoveScenarioColumnFromDeals < ActiveRecord::Migration
  def change
    remove_column :deals, :scenario, default: 1
  end
end
