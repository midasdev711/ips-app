class AddKickbackToLenders < ActiveRecord::Migration
  def change
    add_column :lenders, :kickback, :boolean, default: false
  end
end
