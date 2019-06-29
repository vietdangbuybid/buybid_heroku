# This migration comes from spree_buybid_core (originally 20190510072438)
class AddAddressFieldToBuybidSellers < ActiveRecord::Migration[5.2]
  def up
    add_column :buybid_sellers, :address, :text
  end

  def down
    remove_column :buybid_sellers, :address, :text
  end
end
