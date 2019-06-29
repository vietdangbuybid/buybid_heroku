class CreateBuybidBatchMarketSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :buybid_batch_market_settings do |t|
      t.string :setting_key
      t.string :setting_values

      t.timestamps
    end
  end
end
