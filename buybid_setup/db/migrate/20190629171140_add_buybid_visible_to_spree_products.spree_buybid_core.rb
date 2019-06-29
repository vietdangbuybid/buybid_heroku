# This migration comes from spree_buybid_core (originally 20190613043840)
class AddBuybidVisibleToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :spree_products, :buybid_visible, :boolean
  end
end
