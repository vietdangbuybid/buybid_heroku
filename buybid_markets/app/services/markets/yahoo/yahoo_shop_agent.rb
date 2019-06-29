require 'yahoo/api'
require 'metainspector'

module Markets::Yahoo
	class YahooShopAgent < Markets::MarketAgent
		def initialize(buybid_market_name, settings)
			super(buybid_market_name, settings)
		end

		def search_products(page_size, page_index, filters)
			search_params = {
				:hits => page_size.to_s,
				:offset => (page_size*page_index).to_s,
				:appid => 'dj00aiZpPTRJMWgyeXdCQ1JwNiZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-',#@settings[:app_id],
				:affiliate_type => @settings[:affiliate_type],
				:affiliate_id => '9SKOlMKVQhGG0EWefFsLOZVPIXKSnrvGEDj8rzIS',#@settings[:affiliate_id]
			}

			if filters[:market_category_id].present?
				search_params[:category_id] = filters[:market_category_id].to_s
			else
			  search_params[:category_id] = @settings[:yahoo_shop_root_category_id].to_s
			end

			res = Yahoo::Api.get(Yahoo::Api::Shopping::ItemSearch, search_params)

			result = {
				products: [],
				sellers: [],
				filters: filters,
				page_size: page_size,
				page_index: page_index
			}

			return result unless res["ResultSet"].present? and res["ResultSet"]["totalResultsReturned"].present?

			category_setting = @settings[:categories].detect { |category_setting| category_setting[:yahoo_shop_category_id] == filters[:market_category_id] }

			res["ResultSet"]["totalResultsReturned"].times do |i|
				product_json =  res["ResultSet"]["0"]["Result"]["#{i}"]

				product_raw = get_deep_hash(product_json)

				properties = [] + category_setting[:properties]
				option_values = [] + category_setting[:option_values]
				tags = [] + category_setting[:tags]

				properties.push({
					name: 'Shipping',
					value: "#{product_raw['shipping']['code']} - #{product_raw['shipping']['name']}"
				}) if product_raw['shipping'].present?

				append_property(properties, product_raw, 'code', 'Code')
				append_property(properties, product_raw, 'condition', 'Condition')
				append_property(properties, product_raw, 'headline', 'Headline')
				append_property(properties, product_raw, 'url', 'Url')
				append_property(properties, product_raw, 'release_date', 'Release date')
				append_property(properties, product_raw, 'jan_code', 'Jan code')
				append_property(properties, product_raw, 'model', 'Model')
				append_property(properties, product_raw, 'isbn_code', 'ISBN code')

				append_property_review(properties, product_raw)

				tags.push(product_raw['code'])
				tags.push(product_raw['store']['id']) if product_raw['store'].present?
				tags.push(product_raw['image']['id']) if product_raw['image'].present?
				tags.uniq!

				image_url = product_raw['image']['medium'] if product_raw['image'].present?

				product = create_product(product_raw, tags, category_setting, properties, option_values, image_url)
				seller = create_seller(product_raw['store'])

				result[:products].push(product)
				result[:sellers].push(seller)
			end
			result
		end

		def get_product(product_id) 
			res = Yahoo::Api.get(Yahoo::Api::Shopping::ItemLookup,{
				:itemcode => product_id.to_s,
				:appid => @settings[:app_id],
				:affiliate_type => @settings[:affiliate_type],
				:affiliate_id => @settings[:affiliate_id]})

			result = {
				product_id: product_id,
				product: {}
			}

			if res["ResultSet"]["totalResultsReturned"].to_i == 0
				return result
			end

			res["ResultSet"]["0"]["Result"].each do |i,v|
				next unless i =~ /\d+/
				product_raw = get_deep_hash(v)

				properties = []
				tags = []

				properties.push({
					name: 'Code',
					value: product_id
				})

				append_property(properties, product_raw, 'condition', 'Condition')
				append_property(properties, product_raw, 'headline', 'Headline')
				append_property(properties, product_raw, 'url', 'Url')

				tags.push(product_id)

				image_url = product_raw['image']['small'] if product_raw['image'].present?

				result[:product] = create_product(product_raw, tags, {}, properties, {}, image_url)
				result[:seller] = create_seller(product_raw['store']) if product_raw['store'].present?
			end
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

		def append_property_review(properties, product_raw)
			return unless product_raw['review'].present?

			properties.push({
				name: 'Review rate',
				value: product_raw['review']['rate']
			}) if product_raw['review']['rate'].present?
			
			properties.push({
				name: 'Review count',
				value: product_raw['review']['count']
			}) if product_raw['review']['count'].present?
			
			properties.push({
				name: 'Review url',
				value: product_raw['review']['url']
			}) if product_raw['review']['url'].present?
		end

		def create_product(product_raw, tags, category_setting, properties, option_values, image_url)
			{
				attributes: {
					buybid_market_name: @buybid_market_name,
					buybid_product_code: product_raw['code'],
					name: product_raw['name'], 
					description: product_raw['description'], 						
					tax_category_id: category_setting[:tax_category_id], 
					price: product_raw['price']['_value'],
					currency: product_raw['price']['_attributes']['currency'], 
					shipping_category_id: category_setting[:shipping_category_id],
					meta_title: product_raw['name'],
					meta_keywords: tags.join(", "),
					meta_description: product_raw['description'],
					tag_list: tags
				},
				buybid_category_ids: category_setting[:buybid_category_ids],
				option_values: option_values,
				properties: properties,
				image_url: image_url,
				seller_code: product_raw['store']['id'],
				buybid_market_name: @buybid_market_name
			}
		end

		def create_seller(seller)
			{
				attributes: {
					seller_code: seller['id'],
					name: seller['name'],
					account_code: "YAHOO-#{seller['id']}",
					description: 'Seller\'s information downloaded from Yahoo Shop',
					rating_point: seller['ratings']['rate'],
					rating_url: seller['url'],
					URL: seller['url'],
					popular: seller['is_best_store'],
					shopper: true,
					is_deleted: false,
					position: 1000,
					order_count: 0
				},
				seller_code: seller['id'],
				buybid_market_name: @buybid_market_name,
				image_url: seller['image']['medium']
			}
		end
	end
end
