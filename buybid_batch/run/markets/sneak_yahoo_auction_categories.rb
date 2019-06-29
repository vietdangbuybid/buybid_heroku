require 'yahoo/api'
require 'metainspector'
require 'stringex'
require 'activerecord-import'

 # initialize
TAXON_NAME_PREFIX = "yahoo_auction-"

categories_root = Spree::Taxonomy.where({ name: 'Categories' }).first_or_create!
taxons_store = Hash.new
taxons_store["categories"] = Spree::Taxon.where(name: "Categories").first
taxons_business_auction = Spree::Taxon.where(name: 'auctions').first

yahoo_auction_categories_count = 1
yahoo_auction_categories = {}
yahoo_auction_depths = []

yahoo_auction_categories['0'] = {
	name: 'Categories'
}

yahoo_auction_depths[0] = {
	categories: {
		"0": {
			name: "Categories"
		}
	},
	depth_counter: 1
}

# add category from yahoo-api to yahoo_auction_categories
def add_category(category, categories_hash, depths, queue)
	return false unless (category["IsLink"] == "false")
	return false unless (category["IsLeafToLink"] == "false")
	
	if categories_hash[category["CategoryId"]].present?
		Rails.logger.info "Existing category: #{category['CategoryId']} - #{category['CategoryName']}"
		return false
	end

	new_category = {
		id: category["CategoryId"],
		name: category["CategoryName"],
		parent_id: category["ParentCategoryId"],
		is_leaf: (category["IsLeaf"] == "false")
	}
	
	# add to depths
	depth_level = category['Depth'].to_i
	unless depths[depth_level].is_a?(Hash)
		depths[depth_level] = {
			categories: Hash.new,
			depth_counter: 0
		}
	end
	depths[depth_level][:categories][category["CategoryId"]] = new_category
	depths[depth_level][:depth_counter] += 1
	
	# add to categories
	categories_hash[category["CategoryId"]] = new_category
	
	queue << category["CategoryId"] if (category["IsLeaf"] == "false")
	true
end

# get taxon from db, store it into taxons_store to avoid "multiple query to single record"
def get_taxon_from_db(store, taxon_name)
	return store[taxon_name] if store[taxon_name].present?

	taxon = Spree::Taxon.where(name: TAXON_NAME_PREFIX + taxon_name).first
	return unless taxon.present?
	store[taxon_name] = taxon

	taxon	
end

Rails.logger.info '- Sneaking Yahoo auction categories'

search_params = {
	:appid => 'dj00aiZpPTRJMWgyeXdCQ1JwNiZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-',
	:affiliate_type => 'yid',
	:affiliate_id => '9SKOlMKVQhGG0EWefFsLOZVPIXKSnrvGEDj8rzIS',
}

queue = Queue.new

queue << '0'

request_count = 1

time_counting_start = Time.now
loop do
	break if request_count > 100
	request_count += 1

	Rails.logger.info "yahoo_auction_categories_count/queue_size: #{yahoo_auction_categories_count}/#{queue.size}"
	
	break if queue.empty?
	search_params[:category] = queue.pop

	res = Yahoo::Api.get(Yahoo::Api::Auction::CategoryTree, search_params)

	next unless res.dig("ResultSet", "Result", "ChildCategory").present?

	if res["ResultSet"]["Result"]["ChildCategory"].is_a?(Hash)
		category = res["ResultSet"]["Result"]["ChildCategory"]
		if add_category(category, yahoo_auction_categories, yahoo_auction_depths, queue)
			yahoo_auction_categories_count += 1
		end
	else
		res["ResultSet"]["Result"]["ChildCategory"].each do |category|
			if add_category(category, yahoo_auction_categories, yahoo_auction_depths, queue)
				yahoo_auction_categories_count += 1
			end
		end
	end
	Rails.logger.info 'Sleeping...'
	sleep 5.seconds
end
Rails.logger.info "Downloading yahoo auction categories. Time counting : #{Time.now - time_counting_start}"

# Fetch done
Rails.logger.info "Fetching data from Yahoo-Api DONE! categories: #{yahoo_auction_categories_count}"
yahoo_auction_depths.each_with_index do |depth_category, i|
	Rails.logger.info "Fetching #{depth_category[:depth_counter]} in depth_level #{i}"
end

# looping though yahoo_auction_categories, save to db by each depth
time_counting_start = Time.now
total_taxons_saved = 0

yahoo_auction_category_id_buybid_category_ids_map = {}
buybid_category_name_yahoo_auction_ids_map = {}

yahoo_auction_depths.each_with_index do |depth_category, depth_level|
	next if depth_category[:depth_counter] == 0

	taxon_children = []

	depth_category[:categories].each do |key, yahoo_auction_category|
		next unless yahoo_auction_category[:parent_id].present?

		parent_id = yahoo_auction_category[:parent_id]
		taxon_parent = get_taxon_from_db(taxons_store, yahoo_auction_categories[parent_id][:name])
		unless taxon_parent.present?
			taxon_parent = taxons_store["categories"]
		end

		existing = get_taxon_from_db(taxons_store, yahoo_auction_category[:name])

		if existing.present?
			unless yahoo_auction_category_id_buybid_category_ids_map[yahoo_auction_category[:id]].present?
				yahoo_auction_category_id_buybid_category_ids_map[yahoo_auction_category[:id]] = [taxons_business_auction.id]
			end
			yahoo_auction_category_id_buybid_category_ids_map[yahoo_auction_category[:id]].push(existing.id)
			next
		end

		unless buybid_category_name_yahoo_auction_ids_map[yahoo_auction_category[:name]].present?
			buybid_category_name_yahoo_auction_ids_map[yahoo_auction_category[:name]] = [taxons_business_auction.id]
		end
		buybid_category_name_yahoo_auction_ids_map[yahoo_auction_category[:name]].push(yahoo_auction_category[:id])
		
		taxon_child = Spree::Taxon.new({
			name: TAXON_NAME_PREFIX + yahoo_auction_category[:name],
			permalink: yahoo_auction_category[:name].to_url
		})
		taxon_child[:depth] = depth_level
		taxon_child.taxonomy = categories_root
		taxon_child.parent = taxon_parent

		# taxon_child.save!
		taxon_children << taxon_child
	end
	
	# taxon_children.save!
	# taxon_children.each(&:save)

	Spree::Taxon.import taxon_children
	total_taxons_saved += taxon_children.count
	Rails.logger.info "Saved #{taxon_children.count} categories in #depth_level #{depth_level}"
end

Spree::Taxon.rebuild!(false)

Rails.logger.info "Saved #{total_taxons_saved} taxons"
Rails.logger.info "Saving records. Time counting : #{Time.now - time_counting_start}"

if buybid_category_name_yahoo_auction_ids_map.present?
	buybid_category_name_yahoo_auction_ids_map.each do |name, yahoo_auction_category_ids|
		buybid_category = get_taxon_from_db(taxons_store, name)
		
		yahoo_auction_category_ids.each do |yahoo_auction_category_id|
			unless yahoo_auction_category_id_buybid_category_ids_map[yahoo_auction_category_id].present?
				yahoo_auction_category_id_buybid_category_ids_map[yahoo_auction_category_id] = []
			end
			yahoo_auction_category_id_buybid_category_ids_map[yahoo_auction_category_id].push(buybid_category.id)
		end
	end
end

yahoo_auction_category_settings = []

yahoo_auction_category_id_buybid_category_ids_map.each do |yahoo_auction_category_id, buybid_category_ids|
	tags = []
	tags << yahoo_auction_categories[yahoo_auction_category_id][:name] if yahoo_auction_categories[yahoo_auction_category_id].present?
	tags << yahoo_auction_categories[yahoo_auction_category_id][:name].to_url if yahoo_auction_categories[yahoo_auction_category_id].present?
	tags << yahoo_auction_categories[yahoo_auction_category_id][:id] if yahoo_auction_categories[yahoo_auction_category_id].present?
	tags << yahoo_auction_categories[yahoo_auction_category_id][:parent_id] if yahoo_auction_categories[yahoo_auction_category_id].present? && yahoo_auction_categories[yahoo_auction_category_id][:parent_id] != '0'

	yahoo_auction_category_settings.push({
				yahoo_auction_category_id: yahoo_auction_category_id,
				buybid_category_ids: buybid_category_ids.uniq,
				shipping_category_id: 1,
				tax_category_id: 1,
				option_values: [],
				properties: [
					{
						name: 'Source',
						value: "Yahoo Auction - Cat \##{yahoo_auction_category_id}"
					}
				],
				tags: tags
			})
end

yahoo_auction_martket_setting = BuybidBatch::MarketSetting.where(setting_key: 'yahoo_auction').first
yahoo_auction_martket_setting_values_hash = yahoo_auction_martket_setting.values_hash
yahoo_auction_martket_setting_values_hash[:categories] = yahoo_auction_category_settings
yahoo_auction_martket_setting.setting_values = yahoo_auction_martket_setting_values_hash.deep_stringify_keys.to_s
yahoo_auction_martket_setting.save!
