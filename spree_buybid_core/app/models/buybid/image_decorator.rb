module Buybid
  module ImageDecorator
    module ClassMethods
      def styles
        {
          mini:    '64x64>',
          small:   '100x100>',
          product: '240x240>',
          large:   '600x600>',
        }
      end
    end

    def self.prepended(base)
      base.has_one :buybid_seller_logo, class_name: 'Buybid::SellerLogo', dependent: :destroy, foreign_key: :spree_asset_id
      base.has_one :buybid_seller, class_name: 'Buybid::Seller', through: :buybid_seller_logo, foreign_key: :spree_asset_id
      base.inheritance_column = nil
      base.singleton_class.prepend Buybid::ImageDecorator::ClassMethods
    end

    def product_url
      url_for(self.url(:product))
    end

  end
end

Spree::Image.prepend Buybid::ImageDecorator
