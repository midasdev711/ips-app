class AddResidualCentsToOptions < ActiveRecord::Migration
  def change
    add_column :options, :residual_cents, :integer, default: 0
  end
end
