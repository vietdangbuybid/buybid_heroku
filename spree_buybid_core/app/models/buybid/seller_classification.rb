module Buybid
  class SellerClassification < Spree::Base
    self.table_name = 'buybid_seller_taxons'
    belongs_to :spree_taxons, foreign_key: :spree_taxon_id, class_name: 'Spree::Taxon'
    belongs_to :buybid_sellers, foreign_key: :buybid_seller_id, class_name: 'Buybid::Seller'
  end
end
