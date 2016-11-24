class AddFrequencyColumnToLenders < ActiveRecord::Migration[5.0]
  def change
    add_column :lenders, :frequency, :integer
  end
end
