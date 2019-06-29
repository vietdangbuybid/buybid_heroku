class CorrectBuybidColumnNamesAndAddProductHeadline < ActiveRecord::Migration[5.2]
  def change
    rename_column :spree_products, :market_name, :buybid_market_name
    rename_column :spree_products, :product_code, :buybid_product_code
    add_column :spree_products, :buybid_headline, :string
  end
end
