class MigrateInsuranceProfitToInsuranceProfitRateInProductLists < ActiveRecord::Migration[5.0]
  def up
     ProductList.all.each do |product_list|
      product_list.insurance_profit_rate = (product_list.insurance_profit_rate / 100).round(4)
      product_list.save! validate: false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
