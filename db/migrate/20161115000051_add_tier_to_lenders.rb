class AddTierToLenders < ActiveRecord::Migration[5.0]
  def change
    add_column :lenders, :tier, :integer
  end
end
