class RemoveResidualFromLenders < ActiveRecord::Migration
  def change
    remove_column :lenders, :residual
  end
end
