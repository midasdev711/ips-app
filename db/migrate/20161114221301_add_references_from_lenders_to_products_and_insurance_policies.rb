class AddReferencesFromLendersToProductsAndInsurancePolicies < ActiveRecord::Migration[5.0]
  def change
    create_table :lenders_products, id: false, force: :cascade do |t|
      t.integer :lender_id
      t.integer :product_id
    end

    add_column :insurance_terms, :lender_id, :integer
  end
end
