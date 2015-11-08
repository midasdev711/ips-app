class AddAmortizationToOptions < ActiveRecord::Migration
  def change
    add_column :options, :amortization, :integer, default: 0
  end
end
