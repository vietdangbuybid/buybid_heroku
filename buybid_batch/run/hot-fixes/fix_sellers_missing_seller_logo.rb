
Spree::Asset.where(viewable_type: 'Buybid::Seller').each do |seller_image|
	seller = Buybid::Seller.find(seller_image.viewable_id)
	if seller.present? && seller.buybid_seller_logo.nil?
		Rails.logger.info 'Create logo'
		Buybid::SellerLogo.create!({
			spree_asset_id: seller_image.id,
			buybid_seller_id: seller.id
		})
	end
end
