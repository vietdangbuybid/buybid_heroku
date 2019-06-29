class ChangeMarketSettingToLongText < ActiveRecord::Migration[5.2]
  def up
    change_column :buybid_batch_market_settings, :setting_values, :longtext
  end

  def down
    change_column :buybid_batch_market_settings, :setting_values, :text
  end
end
