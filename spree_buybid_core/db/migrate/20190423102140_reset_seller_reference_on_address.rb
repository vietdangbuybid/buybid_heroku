class ResetSellerReferenceOnAddress < ActiveRecord::Migration[5.2]
  def change
    remove_reference :spree_addresses, :buybid_seller
    add_reference :spree_addresses, :buybid_seller, foreign_key: true 
  end
end
