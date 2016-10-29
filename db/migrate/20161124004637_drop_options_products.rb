class DropOptionsProducts < ActiveRecord::Migration[5.0]
  def change
    drop_table :options_products
  end
end
