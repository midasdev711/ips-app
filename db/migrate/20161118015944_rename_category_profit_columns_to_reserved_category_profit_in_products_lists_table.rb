class RenameCategoryProfitColumnsToReservedCategoryProfitInProductsListsTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :product_lists, :car_profit_cents,    :car_reserved_profit_cents
    rename_column :product_lists, :family_profit_cents, :family_reserved_profit_cents
  end
end
