class AddTrendStatusesToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :hots, :boolean
    add_column :spree_products, :news, :boolean
    add_column :spree_products, :populars, :boolean
  end
end
