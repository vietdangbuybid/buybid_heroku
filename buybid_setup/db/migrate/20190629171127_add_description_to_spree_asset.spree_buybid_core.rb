# This migration comes from spree_buybid_core (originally 20190429034613)
class AddDescriptionToSpreeAsset < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_assets, :description, :text
  end
end
