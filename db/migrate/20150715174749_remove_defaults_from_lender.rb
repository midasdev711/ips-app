class RemoveDefaultsFromLender < ActiveRecord::Migration
  def change
    change_column_default :lenders, :msrp_cents, nil
  end
end
