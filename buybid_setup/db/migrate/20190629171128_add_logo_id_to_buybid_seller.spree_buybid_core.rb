# This migration comes from spree_buybid_core (originally 20190429073724)
class AddLogoIdToBuybidSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :logo_id, :int
  end
end
