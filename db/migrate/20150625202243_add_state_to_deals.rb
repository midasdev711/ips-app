class AddStateToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :state, :integer
  end
end
