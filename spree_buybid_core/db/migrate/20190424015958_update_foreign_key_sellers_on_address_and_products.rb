class UpdateForeignKeySellersOnAddressAndProducts < ActiveRecord::Migration[5.2]
  def change 
    remove_reference :spree_products, :buybid_seller, index: true
    remove_reference :spree_addresses, :buybid_seller, index: true
    add_reference :spree_products, :buybid_seller, index: true, foreign_key: true 
    add_reference :spree_addresses, :buybid_seller, index: true, foreign_key: true 
  end
end
