class RemoveResidualUnit < ActiveRecord::Migration
  def change
    remove_column :lenders, :residual_unit
  end
end
