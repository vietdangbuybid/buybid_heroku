# This migration comes from spree_buybid_core (originally 20190426080439)
class AddProductCodeToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :product_code, :string
  end
end
