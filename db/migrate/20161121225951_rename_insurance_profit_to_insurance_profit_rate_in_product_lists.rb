class RenameInsuranceProfitToInsuranceProfitRateInProductLists < ActiveRecord::Migration[5.0]
  def change
    rename_column :product_lists, :insurance_profit, :insurance_profit_rate
    change_column :product_lists, :insurance_profit_rate, :float
  end
end
