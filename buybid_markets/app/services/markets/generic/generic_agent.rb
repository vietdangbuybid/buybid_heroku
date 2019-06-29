require 'metainspector'

module Markets::Generic
	class GenericAgent < Markets::MarketAgent
		def initialize(buybid_market_name, settings)
			super(buybid_market_name, settings)
		end
		
		def search_products(page_size, page_index, filters)
			result = {
				products: [],
				sellers: [],
				filters: filters,
				page_size: page_size,
				page_index: page_index
			}
			result
		end

		def get_product(product_id) 
			result = {
				product_id: product_id,
				product: {},
				seller: {}
			}
			result
		end

		def parse_link(link_url)
			meta_inspector = MetaInspector.new(link_url)
			meta_inspector.meta.merge('title' => meta_inspector.title)
		end
	end
end
