# This migration comes from spree_buybid_core (originally 20190425120536)
class AddIndexPositionOnBuybidSeller < ActiveRecord::Migration[5.2]
  def change
    add_index :buybid_sellers, :position
  end
end
