# This migration comes from spree_buybid_core (originally 20190605045218)
class CorrectNamingOnBuybidColumnsAddedToSpree < ActiveRecord::Migration[5.2]
  def change
    rename_column :spree_taxons, :auctions, :buybid_auction
    rename_column :spree_taxons, :shops,    :buybid_shop
    rename_column :spree_taxons, :partners, :buybid_partner
    rename_column :spree_taxons, :store,    :buybid_store

    change_column :spree_taxons, :buybid_auction, :int, default: 0
    change_column :spree_taxons, :buybid_shop, :int, default: 0
    change_column :spree_taxons, :buybid_partner, :int, default: 0
    change_column :spree_taxons, :buybid_store, :int, default: 0

    rename_column :spree_products, :auctions, :buybid_auction
    rename_column :spree_products, :shops,    :buybid_shop
    rename_column :spree_products, :partners, :buybid_partner
    rename_column :spree_products, :store,    :buybid_store
    rename_column :spree_products, :hots,     :buybid_hot
    rename_column :spree_products, :news,     :buybid_new
    rename_column :spree_products, :populars, :buybid_popular

    change_column :spree_products, :buybid_auction, :int, default: 0
    change_column :spree_products, :buybid_shop, :int, default: 0
    change_column :spree_products, :buybid_partner, :int, default: 0
    change_column :spree_products, :buybid_store, :int, default: 0
    change_column :spree_products, :buybid_hot, :int, default: 0
    change_column :spree_products, :buybid_new, :int, default: 0
    change_column :spree_products, :buybid_popular, :int, default: 0

    rename_column :buybid_sellers, :shopper, :shop

    change_column :buybid_sellers, :auction, :int, default: 0
    change_column :buybid_sellers, :shop, :int, default: 0
    change_column :buybid_sellers, :partner, :int, default: 0
    change_column :buybid_sellers, :popular, :int, default: 0

    add_column :buybid_sellers, :store, :int, default: 0
  end
end
