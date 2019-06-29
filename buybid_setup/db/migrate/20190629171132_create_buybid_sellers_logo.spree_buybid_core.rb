# This migration comes from spree_buybid_core (originally 20190517041356)
class CreateBuybidSellersLogo < ActiveRecord::Migration[5.2]
  def up
    create_table :buybid_seller_logo do |t|
      t.belongs_to :buybid_seller, index: true
      t.belongs_to :spree_asset, index: true
    end
  end

  def down
    drop_table :buybid_seller_logo
  end
end
