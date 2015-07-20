class RemoveMoreDefaults < ActiveRecord::Migration
  def change
    change_column_default :deals, :payment_max_cents, nil
    change_column_default :deals, :payment_min_cents, nil
    change_column_default :options, :residual_cents, nil
  end
end
