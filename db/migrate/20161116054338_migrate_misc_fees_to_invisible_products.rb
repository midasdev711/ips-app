class MigrateMiscFeesToInvisibleProducts < ActiveRecord::Migration[5.0]
  def up
    Product.where(name: 'Misc. fees').each do |product|
      product.update_columns visible: false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
