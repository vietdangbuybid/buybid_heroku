class Buybid::Seller::Create < Buybid::Seller::Abstract
	attr_reader :seller, :seller_attrs

	def initialize(seller_attrs)
		super()
		@seller_attrs = seller_attrs
    @seller = update_by_code_or_ceate(@seller_attrs[:seller_code], @seller_attrs)
	end

	def execute
    seller.save
    seller
	end		

	private

  def update_by_code_or_ceate(seller_code, seller_attrs)
    seller = Buybid::Seller.find_by(seller_code: seller_code)
    if seller.present?
      seller.update_attributes(seller_attrs.except(:description, :position, :URL))
    else
      seller = Buybid::Seller.new(seller_attrs)
    end
    seller
  end
end
