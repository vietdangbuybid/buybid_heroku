class CreateBuybidSellerTaxons < ActiveRecord::Migration[5.2]
  def up
    create_table :buybid_seller_taxons do |t|
      t.belongs_to :buybid_seller, index: true
      t.belongs_to :spree_taxon, index: true
      t.integer :position
      t.timestamps
    end
  end

  def down
    drop_table :buybid_seller_taxons
  end
end
