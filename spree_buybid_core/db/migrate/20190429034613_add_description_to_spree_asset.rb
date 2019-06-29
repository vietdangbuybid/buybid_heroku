class AddDescriptionToSpreeAsset < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_assets, :description, :text
  end
end
