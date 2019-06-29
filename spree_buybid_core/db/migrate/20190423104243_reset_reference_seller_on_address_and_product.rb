class ResetReferenceSellerOnAddressAndProduct < ActiveRecord::Migration[5.2]
  def change
    remove_reference :spree_products, :buybid_seller, index: true, foreign_key: true
    remove_reference :spree_addresses, :buybid_seller, index: true, foreign_key: true
    add_reference :spree_products, :buybid_seller, index: true, foreign_key: {to_table: :buybid_sellers}
    add_reference :spree_addresses, :buybid_seller, index: true, foreign_key: {to_table: :buybid_sellers} 
  end
end
