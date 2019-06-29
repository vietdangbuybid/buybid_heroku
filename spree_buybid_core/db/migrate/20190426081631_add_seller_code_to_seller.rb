class AddSellerCodeToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :seller_code, :string
  end
end
