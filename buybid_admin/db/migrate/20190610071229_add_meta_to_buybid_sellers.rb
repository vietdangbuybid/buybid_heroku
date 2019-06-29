class AddMetaToBuybidSellers < ActiveRecord::Migration[5.2]
  def change
    add_column :buybid_sellers, :meta_keywords, :string
    add_column :buybid_sellers, :meta_title, :string
    add_column :buybid_sellers, :meta_description, :text
  end
end
