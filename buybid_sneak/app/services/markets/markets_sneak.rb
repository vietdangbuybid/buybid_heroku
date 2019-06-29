module Markets
	class MarketsSneak
		class << self
			def search_product_cards(buybid_market_name, page_index, page_size, filters)
				products = market_agent(buybid_market_name).search_products(page_size, page_index, filters)
				if filters[:market_category_id].present?
					product_cards_queue.publish(JSON.generate(products), headers: { buybid_market_name: buybid_market_name, market_category_id: filters[:market_category_id] }) if products.present?
				else
					product_cards_queue.publish(JSON.generate(products), headers: { buybid_market_name: buybid_market_name }) if products.present?
				end
				products
			end

			def get_product_detail(buybid_market_name, product_id)
				product = market_agent(buybid_market_name).get_product(product_id)
				product_detail_queue.publish(JSON.generate(product), headers: { buybid_market_name: buybid_market_name, product_id: product_id }) if product.present?
				product
			end

			def parse_link(buybid_market_name, link_url)
				market_agent(buybid_market_name).parse_link(link_url)
			end

			private
			
			def market_agent(buybid_market_name)
		    market_settings = BuybidBatch::MarketSetting.where(["setting_key = ?", buybid_market_name]).first!
			  Markets::MarketManager.create_agent_by_market_name(buybid_market_name, market_settings.values_hash)
			end

			def product_cards_queue
				@@product_cards_queue ||= BuybidCommon::Queues::MarketsQueue.fetch_exchange(:fanout, BuybidCommon::Queues::MarketsQueue::MARTKET_PRODUCT_CARDS)
			end

			def product_detail_queue
				@@product_detail_queue ||= BuybidCommon::Queues::MarketsQueue.fetch_exchange(:fanout, BuybidCommon::Queues::MarketsQueue::MARTKET_PRODUCT_DETAIL)
			end
		end
	end
end
