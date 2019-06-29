# This migration comes from spree_buybid_core (originally 20190624123208)
class UpdateSearchCriterialForPriceAndBuybidSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_prices, :buybid_buynow, :integer, default: 0
    add_column :spree_prices, :buybid_current, :integer, default: 0
    add_column :buybid_sellers, :individual, :integer, default: 0
  end
end
