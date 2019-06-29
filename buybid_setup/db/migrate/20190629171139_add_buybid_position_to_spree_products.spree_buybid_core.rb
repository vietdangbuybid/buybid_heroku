# This migration comes from spree_buybid_core (originally 20190611085311)
class AddBuybidPositionToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :spree_products, :buybid_position, :integer
  end
end
