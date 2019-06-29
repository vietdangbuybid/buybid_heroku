module Buybid
  module TaxonDecorator
    def self.prepended(base)
      base.has_many :seller_classifications, class_name: 'Buybid::SellerClassification', foreign_key: :buybid_seller_id
      base.has_many :buybid_sellers, class_name: 'Buybid::Seller', through: :seller_classifications, foreign_key: :buybid_seller_id

      base.scope :buybid_auction, -> { where(buybid_auction: BuybidCommon::BusinessValues::AUCTION) }
      base.scope :not_buybid_auction, -> { where(buybid_auction: BuybidCommon::BusinessValues::NOT_AUCTION) }

      base.scope :buybid_shop, -> { where(buybid_shop: BuybidCommon::BusinessValues::SHOP) }
      base.scope :not_buybid_shop, -> { where(buybid_shop: BuybidCommon::BusinessValues::NOT_SHOP) }

      base.scope :buybid_partner, -> { where(buybid_partner: BuybidCommon::BusinessValues::PARTNER) }
      base.scope :not_buybid_partner, -> { where(buybid_partner: BuybidCommon::BusinessValues::NOT_PARTNER) }

      base.scope :buybid_store, -> { where(buybid_store: BuybidCommon::BusinessValues::STORE) }
      base.scope :not_buybid_store, -> { where(buybid_store: BuybidCommon::BusinessValues::NOT_STORE) }

    end

    def set_permalink
      if parent.present? && parent.parent_id.present?
        self.permalink = [parent.permalink, (permalink.blank? ? name.to_url : permalink.split('/').last)].join('/')
      else
        self.permalink = name.to_url if permalink.blank?
      end
    end
  end
end

Spree::Taxon.prepend Buybid::TaxonDecorator
