Rails.logger.info '- Seeding Buybid Time Schedules'

# Time schedules for sneak product
BuybidBatch::TimeSchedule.where(schedule_key: 'sneak_product_cards_category_1').destroy_all
BuybidBatch::TimeSchedule.create({
	schedule_key: 'sneak_product_cards_category_1',
	task_name: 'sneak_product_cards',
	repeat_time: 5,
	repeat_type: 'seconds',
	repeat_num: nil,
	actived: true,
	schedule_data: {
		buybid_market_name: Markets::MARKET_NAMES[:yahoo_shop],
		yahoo_shop_category_id: 1
	}.deep_stringify_keys.to_s
})
