class AddMainSellerCategoryIdBuybidSellers < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :main_category_id, :integer
  end
end
