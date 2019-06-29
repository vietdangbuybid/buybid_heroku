Rails.logger.info '- Seeding Buybid Taxonomies and Taxons'

taxonomies = [
  { name: I18n.t('spree.taxonomy_categories_name') },
  { name: I18n.t('spree.taxonomy_brands_name') }
]

taxonomies.each do |taxonomy_attrs|
  Spree::Taxonomy.where(taxonomy_attrs).first_or_create!
end

categories_root = Spree::Taxonomy.where({ name: 'Categories' }).first_or_create!
business_models_root = Spree::Taxonomy.where({ name: 'Businesses' }).first_or_create!
hightlights_root = Spree::Taxonomy.where({ name: 'Hightlights' }).first_or_create!


taxonomy_taxons = {
	categories_root => [
		{
			name: 'Zippos'
		},
		{
			name: 'Cameras'
		},
		{
			name: 'Fishings'
		},
		{
			name: 'Audios'
		}
	],
	business_models_root => [
		{
			name: 'Shops'
		},
		{
			name: 'Auctions'
		},
		{
			name: 'Buybidshops'
		},
		{
			name: 'Partners'
		}
	],
	hightlights_root => [
		{
			name: 'Hots'
		},
		{
			name: 'New Arrivals'
		}
	]
}

taxonomy_taxons.each do |taxonomy, taxons|
	taxons.each do |taxon_attrs|
		parent = Spree::Taxon.where(name: taxonomy.name).first
	  taxon = Spree::Taxon.where(name: taxon_attrs[:name]).first_or_create!
	  taxon.taxonomy = taxonomy
	  taxon.parent = parent
	  taxon.save!
	end
end
