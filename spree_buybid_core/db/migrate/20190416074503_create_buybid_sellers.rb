# This migration comes from spree_buybid_core (originally 20190416070323)
class CreateBuybidSellers < ActiveRecord::Migration[5.2]
  def up 
    create_table :buybid_sellers do |t|
      t.string :name
      t.string :account_code
      t.string :phone_number
      t.text :description
      t.float :rating_point
      t.float :rating_total_good
      t.string :float
      t.float :rating_total_bad
      t.float :rating_is_suspended
      t.float :rating_is_deleted
      t.text :rating_url
      t.text :comprehensive_evaluation
      t.text :last_evaluation
      t.boolean :auction
      t.boolean :shopper
      t.boolean :partner
      t.boolean :visible
      t.boolean :popular
      t.integer :order_count
      t.integer :position
      t.boolean :is_deleted

      t.timestamps
    end

    add_reference :spree_products, :buybid_seller, foreign_key: { to_table: :buybid_sellers }
    add_reference :spree_addresses, :buybid_seller, foreign_key: { to_table: :buybid_sellers }
  end

  def down
    drop_table :buybid_sellers
  end
end
