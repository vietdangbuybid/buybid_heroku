buybid_market_name = 'yahoo_auction'
market_settings = BuybidBatch::MarketSetting.where(["setting_key = ?", buybid_market_name]).first.values_hash
market_agent = Markets::MarketManager.create_agent_by_market_name(buybid_market_name, market_settings)

page_size = 20
page_index = 1
loop do
	market_settings[:categories].each do |category|
		begin
			Rails.logger.info "page_index: #{page_index}, cate: #{category[:yahoo_shop_category_id]}"
			yahoo_auction_search = market_agent.search_products(page_size, page_index, { market_category_id: category[:yahoo_auction_category_id], query: '' })
			next unless yahoo_auction_search[:products].count > 0
			Markets::ProductCardsFetch.new(buybid_market_name).on_product(yahoo_auction_search)
		rescue
			Rails.logger.info "Sleeping... after exception #{category[:yahoo_auction_category_id]}"
			sleep 5.seconds
			next
		end
		Rails.logger.info "Sleeping... after cateogry #{category[:yahoo_auction_category_id]}"
		sleep 3.seconds
	end
	page_index = page_index + 1
	Rails.logger.info "Sleeping... before page #{page_index}"
	sleep 5.seconds
end
