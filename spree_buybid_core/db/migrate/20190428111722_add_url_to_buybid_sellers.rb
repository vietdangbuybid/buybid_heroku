class AddUrlToBuybidSellers < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :URL, :string
  end
end
