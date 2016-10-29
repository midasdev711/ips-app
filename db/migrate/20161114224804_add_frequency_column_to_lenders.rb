class AddFrequencyColumnToLenders < ActiveRecord::Migration
  def change
    add_column :lenders, :frequency, :integer
  end
end
