class AddBuybidUrlOriginalToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :spree_products, :buybid_url_original, :string
  end
end
