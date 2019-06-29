class AddBusinessModelsToTaxon < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_taxons, :auctions, :boolean
    add_column :spree_taxons, :shops, :boolean
    add_column :spree_taxons, :partners, :boolean
    add_column :spree_taxons, :store, :boolean
  end
end
