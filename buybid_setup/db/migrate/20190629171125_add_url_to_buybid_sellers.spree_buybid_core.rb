# This migration comes from spree_buybid_core (originally 20190428111722)
class AddUrlToBuybidSellers < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :URL, :string
  end
end
