class MigrateProductsFromOptionsToLenders < ActiveRecord::Migration[5.0]
  def up
    Lender.all.each do |lender|
      option = lender.options.first
      next unless option
      lender.products = option.products
      lender.insurance_terms = option.insurance_terms
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
