class AddBusinessModelsToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :auctions, :boolean
    add_column :spree_products, :shops, :boolean
    add_column :spree_products, :partners, :boolean
    add_column :spree_products, :store, :boolean
  end
end
