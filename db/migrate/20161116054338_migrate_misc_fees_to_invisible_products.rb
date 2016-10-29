class MigrateMiscFeesToInvisibleProducts < ActiveRecord::Migration
  def up
    Product.where(name: 'Misc. fees').each do |product|
      product.visible = false
      product.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
