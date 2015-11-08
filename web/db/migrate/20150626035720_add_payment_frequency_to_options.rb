class AddPaymentFrequencyToOptions < ActiveRecord::Migration
  def change
    add_column :options, :payment_frequency, :integer
  end
end
