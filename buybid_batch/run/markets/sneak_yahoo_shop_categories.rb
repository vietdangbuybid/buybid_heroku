require 'yahoo/api'
require 'metainspector'
require 'stringex'
require 'activerecord-import'

TAXON_NAME_PREFIX = "yahoo_shop-"

categories_root = Spree::Taxonomy.where( name: 'Categories' ).first_or_create!
taxons_store = Hash.new
taxons_store["categories"] = Spree::Taxon.where( name: "Categories" ).first
taxons_business_shop = Spree::Taxon.where(name: 'shops').first

yahoo_shop_categories_count = 1
yahoo_shop_categories = {}
yahoo_shop_depths = []

yahoo_shop_categories["1"] = {
	id: "1",
	name: 'Categories'
}

yahoo_shop_depths[0] = {
	categories: {
		"1": yahoo_shop_categories["1"]
	},
	depth_counter: 1
}

# get taxon from db, store it into taxons_store to avoid "multiple query to single record"
def get_taxon_from_db(store, taxon_name)
	return store[taxon_name] if store[taxon_name].present?

	taxon = Spree::Taxon.where(name: TAXON_NAME_PREFIX + taxon_name).first
	return unless taxon.present?
	store[taxon_name] = taxon

	taxon	
end

def merge_hash(target, hash_props)
	hash_props.each do |key, value|
		target[key] = value
	end
end

def get_categories_at_depth_level(yahoo_shop_categories, depth_level)
	result_categories = Hash.new
	return result_categories unless yahoo_shop_categories[:children].present?

	yahoo_shop_categories[:children].each do |id, categories_hash|
		if depth_level == 1
			result_categories[categories_hash[:id]] = {
				id: categories_hash[:id],
				name: categories_hash[:name],
				parent_id: categories_hash[:parent_id],
				is_leaf: categories_hash[:is_leaf]
			}
			next
		end
		recursion_categories = get_categories_at_depth_level(categories_hash, depth_level - 1)
		unless recursion_categories.empty?
			merge_hash(result_categories, recursion_categories)
		end
	end
	result_categories
end

Rails.logger.info '- Sneaking Yahoo shop categories'

search_params = {
	:appid => 'dj00aiZpPTRJMWgyeXdCQ1JwNiZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-',
	:affiliate_type => 'yid',
	:affiliate_id => '9SKOlMKVQhGG0EWefFsLOZVPIXKSnrvGEDj8rzIS',
}

queue = Queue.new

queue << '1'

request_count = 1

loop do
	break if request_count > 200
	request_count += 1

	Rails.logger.info "yahoo_shop_categories_count: #{yahoo_shop_categories_count}/#{queue.size}"

	break if queue.empty?	
	search_params[:category_id] = queue.pop

	res = Yahoo::Api.get(Yahoo::Api::Shopping::CategorySearch, search_params)

	next unless res.present? && 
		res["ResultSet"].present? && 
		res["ResultSet"]["0"].present? && 
		res["ResultSet"]["0"]["Result"].present? && 
		res["ResultSet"]["0"]["Result"]["Categories"].present? && 
		res["ResultSet"]["0"]["Result"]["Categories"]["Children"].present?
		res['ResultSet']['0']['Result']['Categories']['Current'].present?

	res["ResultSet"]["0"]["Result"]["Categories"]["Children"].each do |index, category|
		if yahoo_shop_categories[category["Id"]].present?
			Rails.logger.info "Existing category: #{category['Id']} - #{category["Title"]['Short']}"
			next
		end

		next unless category["Id"].present? &&
			category["Title"].present? &&
			category["Title"]['Short'].present?
		
		yahoo_shop_categories[category["Id"]] = {
			id: category["Id"],
			name: category["Title"]['Short'],
			parent_id: res['ResultSet']['0']['Result']['Categories']['Current']['Id'],
			is_leaf: (category["IsLeaf"] == "false")
		}
		queue << category["Id"] unless (category["IsLeaf"] == "true")

		yahoo_shop_categories_count += 1
	end
	Rails.logger.info 'Sleeping...'
	sleep 5.seconds
end

Rails.logger.info "Fetching data from Yahoo-API DONE! categories: #{yahoo_shop_categories_count}"

yahoo_shop_category_id_buybid_category_ids_map = {}
buybid_category_name_yahoo_shop_ids_map = {}

yahoo_shop_categories.each do |id, yahoo_shop_category|
	parent_id = yahoo_shop_category[:parent_id]
	next unless parent_id.present?

	parent = yahoo_shop_categories[parent_id]
	unless parent[:children].present?
		parent[:children] = Hash.new
	end
	parent[:children][yahoo_shop_category[:id]] = yahoo_shop_category
end

depth_level = 1
loop do
	categories = get_categories_at_depth_level(yahoo_shop_categories["1"], depth_level)
	break if categories.empty?

	yahoo_shop_depths[depth_level] = {
		categories: categories,
		depth_counter: categories.count
	}
	depth_level += 1
end

# Logging
yahoo_shop_depths.each_with_index do |depth_category, i|
	Rails.logger.info "Fetching #{depth_category[:depth_counter]} in depth_level #{i}"
end

time_counting_start = Time.now
total_taxons_saved = 0
yahoo_shop_depths.each_with_index do |depth_category, depth_level|
	next if depth_category[:depth_counter] == 0

	taxon_children = []
	
	depth_category[:categories].each do |key, yahoo_shop_category|
		next unless yahoo_shop_category[:parent_id].present?

		existing = get_taxon_from_db(taxons_store, yahoo_shop_category[:name])
		if existing.present?
			unless yahoo_shop_category_id_buybid_category_ids_map[yahoo_shop_category[:id]].present?
				yahoo_shop_category_id_buybid_category_ids_map[yahoo_shop_category[:id]] = [taxons_business_shop.id]
			end
			yahoo_shop_category_id_buybid_category_ids_map[yahoo_shop_category[:id]].push(existing.id)
			next
		end

		unless buybid_category_name_yahoo_shop_ids_map[yahoo_shop_category[:name]].present?
			buybid_category_name_yahoo_shop_ids_map[yahoo_shop_category[:name]] = [taxons_business_shop.id]
		end
		buybid_category_name_yahoo_shop_ids_map[yahoo_shop_category[:name]].push(yahoo_shop_category[:id])
		
		parent_id = yahoo_shop_category[:parent_id]
		taxon_parent = get_taxon_from_db(taxons_store, yahoo_shop_categories[parent_id][:name])
		unless taxon_parent.present?
			taxon_parent = taxons_store["categories"]
		end

		taxon_child = Spree::Taxon.new({
			name: TAXON_NAME_PREFIX + yahoo_shop_category[:name],
			permalink: yahoo_shop_category[:name].to_url
		})
		taxon_child[:depth] = depth_level
		taxon_child.taxonomy = categories_root
		taxon_child.parent = taxon_parent

		taxon_children << taxon_child
	end

	Spree::Taxon.import taxon_children
	total_taxons_saved += taxon_children.count
	Rails.logger.info "Saved #{taxon_children.count} categories in #depth_level #{depth_level}"
end

Spree::Taxon.rebuild!(false)

Rails.logger.info "Saved #{total_taxons_saved} taxons"
Rails.logger.info "Saving records. Time counting : #{Time.now - time_counting_start}"

if buybid_category_name_yahoo_shop_ids_map.present?
	buybid_category_name_yahoo_shop_ids_map.each do |name, yahoo_shop_category_ids|
		buybid_category = get_taxon_from_db(taxons_store, name)

		yahoo_shop_category_ids.each do |yahoo_shop_category_id|
			unless yahoo_shop_category_id_buybid_category_ids_map[yahoo_shop_category_id].present?
				yahoo_shop_category_id_buybid_category_ids_map[yahoo_shop_category_id] = []
			end
			yahoo_shop_category_id_buybid_category_ids_map[yahoo_shop_category_id].push(buybid_category.id)
		end
	end
end

yahoo_shop_category_settings = []

yahoo_shop_category_id_buybid_category_ids_map.each do |yahoo_shop_category_id, buybid_category_ids|
	tags = []
	tags << yahoo_shop_categories[yahoo_shop_category_id][:name] if yahoo_shop_categories[yahoo_shop_category_id].present?
	tags << yahoo_shop_categories[yahoo_shop_category_id][:name].to_url if yahoo_shop_categories[yahoo_shop_category_id].present?
	tags << yahoo_shop_categories[yahoo_shop_category_id][:id] if yahoo_shop_categories[yahoo_shop_category_id].present?
	tags << yahoo_shop_categories[yahoo_shop_category_id][:parent_id] if yahoo_shop_categories[yahoo_shop_category_id].present? && yahoo_shop_categories[yahoo_shop_category_id][:parent_id] != '0'

	yahoo_shop_category_settings.push({
				yahoo_shop_category_id: yahoo_shop_category_id,
				buybid_category_ids: buybid_category_ids.uniq,
				shipping_category_id: 1,
				tax_category_id: 1,
				option_values: [],
				properties: [
					{
						name: 'Source',
						value: "Yahoo shop - Cat \##{yahoo_shop_category_id}"
					}
				],
				tags: tags
			})
end

yahoo_shop_martket_setting = BuybidBatch::MarketSetting.where(setting_key: 'yahoo_shop').first
yahoo_shop_martket_setting_values_hash = yahoo_shop_martket_setting.values_hash
yahoo_shop_martket_setting_values_hash[:categories] = yahoo_shop_category_settings
yahoo_shop_martket_setting.setting_values = yahoo_shop_martket_setting_values_hash.deep_stringify_keys.to_s
yahoo_shop_martket_setting.save!
