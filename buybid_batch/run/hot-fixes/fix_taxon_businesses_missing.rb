businesses_taxon = Spree::Taxon.find_by(name: 'businesses')
businesses_taxonomy = Spree::Taxonomy.find_by(name: 'businesses')

partner_taxon = Spree::Taxon.where(name: 'Partners').first_or_create!
partner_taxon.parent = businesses_taxon
partner_taxon.taxonomy = businesses_taxonomy
partner_taxon.save!

buybidshop_taxon = Spree::Taxon.find_by(name: 'At buybid')

if buybidshop_taxon.present?
    buybidshop_taxon[:name] = 'Buybidshops'
    buybidshop_taxon[:permalink] = buybidshop_taxon[:name].to_url
    buybidshop_taxon.save!
end