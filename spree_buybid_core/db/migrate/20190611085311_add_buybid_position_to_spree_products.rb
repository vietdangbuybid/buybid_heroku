class AddBuybidPositionToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :spree_products, :buybid_position, :integer
  end
end
