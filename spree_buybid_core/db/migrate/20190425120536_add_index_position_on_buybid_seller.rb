class AddIndexPositionOnBuybidSeller < ActiveRecord::Migration[5.2]
  def change
    add_index :buybid_sellers, :position
  end
end
