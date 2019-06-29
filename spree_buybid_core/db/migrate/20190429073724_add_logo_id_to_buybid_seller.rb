class AddLogoIdToBuybidSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :logo_id, :int
  end
end
