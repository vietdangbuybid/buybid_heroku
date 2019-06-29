Rails.logger.info '- Test Taxons'

categories_root = Spree::Taxonomy.where({ name: 'Categories' }).first_or_create!

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
	]
}

taxonomy_taxons.each do |taxonomy, taxons|
	taxons.each do |taxon_attrs|
		parent = Spree::Taxon.where(name: taxonomy.name).first
	  taxon = Spree::Taxon.where(name: taxon_attrs[:name]).first_or_create!
	  byebug
	  taxon.taxonomy = taxonomy
	  byebug
	  taxon.parent = parent
	  byebug
	  taxon.save!
	end
end
