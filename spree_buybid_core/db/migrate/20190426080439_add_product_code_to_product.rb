class AddProductCodeToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :product_code, :string
  end
end
