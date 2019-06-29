class Buybid::Seller::Delete < Buybid::Seller::Abstract
  attr_reader :seller, :seller_id

  def initialize(seller_id)
    super()
    @seller_id = seller_id
    @seller = Buybind::Seller.find(seller_id)
  end

  def execute
    seller.restore
    seller.save
  end
end
