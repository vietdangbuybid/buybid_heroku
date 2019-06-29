class AddBuybidVisibleToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :spree_products, :buybid_visible, :boolean
  end
end
