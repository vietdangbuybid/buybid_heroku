Rails.logger.info '- Seeding Buybid Market Settings'

# Settings for Yahoo 
BuybidBatch::MarketSetting.where(setting_key: 'yahoo_shop').destroy_all
BuybidBatch::MarketSetting.create({
	setting_key: 'yahoo_shop',
	setting_values: {
		app_id: 'dj00aiZpPVpndTRFTFJrblNibSZzPWNvbnN1bWVyc2VjcmV0Jng9YzM-',
		affiliate_type: 'yid',
		affiliate_id: '2ZfqQQpbnzLK5dNVi9inVTvxfDY8Q4viNAe3j5gv',
		yahoo_shop_root_category_id: 44812,
		categories: []
	}.deep_stringify_keys.to_s
}) 

# Setting for yahoo Auction
BuybidBatch::MarketSetting.where(setting_key: 'yahoo_auction').destroy_all
BuybidBatch::MarketSetting.create({
	setting_key: 'yahoo_auction',
	setting_values: {
		app_id: 'dj00aiZpPVpndTRFTFJrblNibSZzPWNvbnN1bWVyc2VjcmV0Jng9YzM-',
		affiliate_type: 'yid',
		affiliate_id: '2ZfqQQpbnzLK5dNVi9inVTvxfDY8Q4viNAe3j5gv',
		yahoo_auction_root_category_id: 42530,
		categories: []
	}.deep_stringify_keys.to_s
})

# Setting for Generic
BuybidBatch::MarketSetting.where(setting_key: 'generic').destroy_all
BuybidBatch::MarketSetting.create({
	setting_key: 'generic',
	setting_values: {
	}.deep_stringify_keys.to_s
})
