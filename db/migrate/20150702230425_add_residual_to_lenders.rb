class AddResidualToLenders < ActiveRecord::Migration
  def change
    add_column :lenders, :residual, :integer, default: 0
  end
end
