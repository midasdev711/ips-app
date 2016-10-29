class AddTierToLenders < ActiveRecord::Migration
  def change
    add_column :lenders, :tier, :integer
  end
end
