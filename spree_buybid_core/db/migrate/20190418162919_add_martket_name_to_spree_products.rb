class AddMartketNameToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :market_name, :string
  end
end
