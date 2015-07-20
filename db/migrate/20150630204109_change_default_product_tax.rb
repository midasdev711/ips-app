class ChangeDefaultProductTax < ActiveRecord::Migration
  def change
    change_column_default :products, :tax, 0
  end
end
