class AddMasterProductListsToAdmins < ActiveRecord::Migration
  def change
    User.where(admin: true).each do |u|
      u.product_list = ProductList.create!
    end
  end
end
