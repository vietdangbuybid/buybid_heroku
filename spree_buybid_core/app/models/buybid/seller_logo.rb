module Buybid
  class SellerLogo < Spree::Base 
    self.table_name = 'buybid_seller_logo'
    belongs_to :spree_image, class_name: 'Spree::Image', foreign_key: :spree_asset_id
    belongs_to :buybid_seller, class_name: 'Buybid::Seller' , foreign_key: :buybid_seller_id
  end
end
