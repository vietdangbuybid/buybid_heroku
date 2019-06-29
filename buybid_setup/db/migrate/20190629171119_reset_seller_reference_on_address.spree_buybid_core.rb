# This migration comes from spree_buybid_core (originally 20190423102140)
class ResetSellerReferenceOnAddress < ActiveRecord::Migration[5.2]
  def change
    remove_reference :spree_addresses, :buybid_seller
    add_reference :spree_addresses, :buybid_seller, foreign_key: true 
  end
end
