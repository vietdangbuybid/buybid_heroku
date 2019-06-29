module Markets
	class MarketAgent		
			def initialize(buybid_market_name, settings)
				@buybid_market_name = buybid_market_name
				@settings = settings
			end
			def search_products(page_size, page_index, query) raise NotImplementedError end
			def get_product(product_id) raise NotImplementedError end
			def parse_link(link_url) raise NotImplementedError end
	end
end
