class RemoveDuplicatedProducts < ActiveRecord::Migration[5.0]
  def up
    Lender.all.each do |lender|
      products_without_duplicates = lender.products.distinct
      lender.products = []
      lender.products = products_without_duplicates
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
