class ChangeDefaultTax < ActiveRecord::Migration
  def change
    change_column_default :deals, :tax, 0
  end
end
