class AddMaxMinFrequencyAndMinFrequencyToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :min_frequency, :integer
    add_column :deals, :max_frequency, :integer
  end
end
