class AddRoundingToLenders < ActiveRecord::Migration
  def change
    add_column :lenders, :rounding, :boolean, default: false
  end
end
