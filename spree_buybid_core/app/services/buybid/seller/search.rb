require 'active_record_union'

class Buybid::Seller::Search < Buybid::Seller::Abstract
  def initialize(params)
    super()
    @params = params
  end

  def execute
    @sellers = case @params[:business]
    when BuybidCommon::BusinessNames::AUCTION
      Buybid::Seller.not_deleted.visible.auction
    when BuybidCommon::BusinessNames::SHOP
      Buybid::Seller.not_deleted.visible.shop
    when BuybidCommon::BusinessNames::PARTNER
      Buybid::Seller.not_deleted.visible.partner
    when BuybidCommon::BusinessNames::STORE
      Buybid::Seller.not_deleted.visible.store
    else
      Buybid::Seller.not_deleted.visible
    end

    if @params[:q]
      @sellers = @sellers.ransack(@params[:q]).result
    end

    @sellers.popular.
      select(*(Buybid::Seller::column_names.map &:to_sym), "#{1_000_000_000_000_000_000} * popular + #{1_000_000_000} * (#{1_000_000_000}-position) + order_count AS sort_number").
    union_all(
      @sellers.not_popular.
    select(*(Buybid::Seller::column_names.map &:to_sym), 'order_count AS sort_number')).
      order('sort_number desc', created_at: :asc)
  end
end
