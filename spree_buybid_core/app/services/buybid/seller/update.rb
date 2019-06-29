class Buybid::Seller::Update < Buybid::Seller::Abstract
	attr_reader :seller_id, :seller_attrs

	def initialize(seller_id, seller_attrs)
		super()
		@seller_id = seller_id
		@seller_attrs = seller_attrs
	end

	def execute
		Buybind::Seller.update(seller_id, { :title => seller_attrs })
	end		
end
