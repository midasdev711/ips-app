class MigrateInsuranceProfitToInsuranceProfitRateInProductLists < ActiveRecord::Migration[5.0]
  def up
     ProductList.all.each do |product_list|
      product_list.update_columns insurance_profit_rate: (product_list.insurance_profit_rate / 100).round(4)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
