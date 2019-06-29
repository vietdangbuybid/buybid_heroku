# This migration comes from spree_buybid_core (originally 20190418162919)
class AddMartketNameToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :market_name, :string
  end
end
