class RenameDealsIndianToStatusIndian < ActiveRecord::Migration
  def change
    rename_column :deals, :indian, :status_indian
  end
end
