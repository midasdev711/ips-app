class DropOptionReferences < ActiveRecord::Migration[5.0]
  def change
    remove_column :insurance_terms, :option_id, :integer
  end
end
