# This migration comes from spree_buybid_core (originally 20190531045434)
class AddTrendStatusesToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :hots, :boolean
    add_column :spree_products, :news, :boolean
    add_column :spree_products, :populars, :boolean
  end
end
