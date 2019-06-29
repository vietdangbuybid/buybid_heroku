require 'yahoo/api'
require 'metainspector'

module Markets::Yahoo
	class YahooAuctionAgent < Markets::MarketAgent
		def initialize(buybid_market_name, settings)
			super(buybid_market_name, settings)
		end
		
		def search_products(page_size, page_index, filters)
			search_params = {
				:query => filters[:query].to_s,
				#:hits => page_size.to_s,
				:page => (page_size*page_index).to_s,
				:appid => 'dj00aiZpPTRJMWgyeXdCQ1JwNiZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-',#@settings[:app_id],
				:affiliate_type => @settings[:affiliate_type],
				:affiliate_id => '9SKOlMKVQhGG0EWefFsLOZVPIXKSnrvGEDj8rzIS',#@settings[:affiliate_id]
			}
			if filters[:market_category_id].present?
				search_params[:category] = filters[:market_category_id].to_s
			else
			  search_params[:category] = @settings[:yahoo_auction_root_category_id].to_s
			end
				
			res = Yahoo::Api.get(Yahoo::Api::Auction::CategoryLeaf, search_params)
				
			result = {
				products: [],
				sellers: [],
				filters: filters,
				page_size: page_size,
				page_index: page_index
			}

			return result unless res["ResultSet"].present? && res["ResultSet"]['@attributes'].present? && res["ResultSet"]['@attributes']['totalResultsReturned'].to_i > 0

			category_setting = @settings[:categories].detect { |category_setting| category_setting[:yahoo_auction_category_id] == filters[:market_category_id] }
			
			res["ResultSet"]["Result"]["Item"].each do |v|
				product_raw = get_deep_hash(v)

				properties = [] + category_setting[:properties]
				option_values = [] + category_setting[:option_values]
				tags = [] + category_setting[:tags]
				
				tags.push(product_raw['auction_id'])
				tags.push(product_raw['seller']['id']) if product_raw['seller'].present?
				tags.push(product_raw['category_id'])
				tags.uniq!
				
				append_property(properties, product_raw, 'bid_or_buy', 'Bid or buy')
				append_property(properties, product_raw, 'end_time', 'End time')
				append_property(properties, product_raw, 'bids', 'Bids')

				image_url = product_raw['image']

				product = create_product(product_raw, tags, category_setting, properties, option_values, image_url)
				seller = create_seller(product_raw['seller'])

				result[:products].push(product)
				result[:sellers].push(seller)
			end
			result
		end

		def get_product(product_id) 
			res = Yahoo::Api.get(Yahoo::Api::Auction::Item,{
				:auctionId => product_id.to_s,
				:appid => @settings[:app_id],
				:affiliate_type => @settings[:affiliate_type],
				:affiliate_id => @settings[:affiliate_id]})

			result = {
				product_id: product_id,
				product: {},
				seller: {}
			}
			
			if res['Error'].present?
				return result
			end

			product_json = res["ResultSet"]["Result"]
			product_raw = get_deep_hash(product_json)

			properties = []
			tags = []

			tags.push(product_raw['category_id']);
			tags.push(product_raw['auction_id'])
			tags.push(product_raw['seller']['id'])
			tags.push(product_raw['seo_keywords'])
			tags.uniq!

			append_property(properties, product_raw, 'category_path', 'Category path')
			append_property(properties, product_raw, 'initprice', 'Init price')
			append_property(properties, product_raw, 'last_initprice', 'Last init price')
			append_property(properties, product_raw, 'quantity', 'Quantity')
			append_property(properties, product_raw, 'availablequantity', 'Available quantity')
			append_property(properties, product_raw, 'watch_list_num', 'Watch list num')
			append_property(properties, product_raw, 'bids', 'Bids')
			append_property(properties, product_raw, 'bidorbuy', 'Bid or buy')
			append_property(properties, product_raw, 'tax_rate', 'Tax rate')
			append_property(properties, product_raw, 'status', 'Status')
			append_property(properties, product_raw, 'start_time', 'Start time')
			append_property(properties, product_raw, 'end_time', 'End time')
			

			image_url = product_raw['img']['image1'] if product_raw['img'].present?

			result[:product] = create_product(product_raw, tags, {}, properties, {}, image_url)
			result[:seller] = create_seller(product_raw['seller'])

			result
		end

		def parse_link(link_url)
			meta_inspector = MetaInspector.new(link_url)
			meta_inspector.meta.merge('title' => meta_inspector.title)
		end

		private
		def get_deep_hash h
			rs = Hash.new
			if h.instance_of? Hash
				h.each do |k, v|
					prop = k \
						.gsub(/([[:lower:]\\d])([[:upper:]])/, '\1 \2') \
						.gsub(/([^-\\d])(\\d[-\\d]*( |$))/,'\1 \2') \
						.gsub(/([[:upper:]])([[:upper:]][[:lower:]\\d])/, '\1 \2') \
						.split(' ') \
						.join('_') \
						.downcase
					rs[prop] = get_deep_hash(v)
				end
			else
				rs = h
			end
			rs
		end

		def append_property(properties, product_raw, key, name)
			properties.push({
				name: name,
				value: product_raw[key]
			}) if product_raw[key].present?
		end

		def create_product(product_raw, tags, category_setting, properties, option_values, image_url)
			{
				attributes: {
					buybid_market_name: @buybid_market_name,
					buybid_product_code: product_raw['auction_id'],
					name: product_raw['title'],
					description: product_raw['description'] || 'no-description',
					tax_category_id: category_setting[:tax_category_id],
					price: product_raw['current_price'] || product_raw['price'],
					currency: 'no-currency',
					shipping_category_id: category_setting[:shipping_category_id],
					meta_title: product_raw['title'],
					meta_keywords: tags.join(', '),
					meta_description: product_raw['description'] || 'no-description',
					tag_list: tags
				},
				buybid_category_ids: category_setting[:buybid_category_ids],
				option_values: option_values,
				properties: properties,
				image_url: image_url,
				seller_code: product_raw['seller']['id'],
				buybid_market_name: @buybid_market_name
			}
		end

		def create_seller(seller)
			seller_hash = {
				seller_code: seller['id'],
				buybid_market_name: @buybid_market_name
			}

			seller_attributes = seller_hash[:attributes] = {
				seller_code: seller['id'],
				name: seller['id'],
				account_code: "YAHOO-#{seller['id']}",
				description: 'Seller\'s information downloaded from Yahoo Auction',
				rating_url: seller['rating_url'],
				is_deleted: false,
				position: 1000,
				order_count: 0,
				URL: "https://auctions.yahoo.co.jp/seller/#{seller['id']}",
				# rating_total_normal: ,
				# comprehensive_evaluation: ,
				# last_evaluation: ,
				# visible: ,
				# popular: ,
				auction: true,
				# shopper: ,
				# partner: ,
				# order_count: ,
				# account_code: ,
				# phone_number: ,
				# position: ,
				# is_deleted: ,
			}

			if seller['rating'].present?
				seller_attributes[:rating_point] = seller['rating']['point']
				seller_attributes[:rating_total_good] = seller['rating']['total_good_rating']
				seller_attributes[:rating_total_bad] = seller['rating']['total_bad_rating']
				seller_attributes[:rating_is_suspended] = seller['rating']['is_suspended']
				seller_attributes[:rating_is_deleted] = seller['rating']['is_deleted']
			end
			seller_attributes[:rating_total_normal] = seller['total_normal_rating'] if seller['total_normal_rating'].present?

			seller_hash
		end
	end
end
