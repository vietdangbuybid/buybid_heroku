# This migration comes from spree_buybid_core (originally 20190426081631)
class AddSellerCodeToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :seller_code, :string
  end
end
