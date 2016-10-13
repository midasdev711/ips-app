class PumpYourResidual < ActiveRecord::Migration
  def change
    add_column :lenders, :residual_value, :integer, default: 0
    add_column :lenders, :residual_unit, :integer, default: 0
    add_column :options, :residual_value, :integer, default: 0
    add_column :options, :residual_unit, :integer, default: 0
  end
end
