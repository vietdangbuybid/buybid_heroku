class Buybid::Taxon::Search < Buybid::Taxon::Abstract
  def initialize(params)
    super()
    @params = params
  end

  def execute
    @taxons = case @params[:business]
    when BuybidCommon::BusinessNames::AUCTION
      Spree::Taxon.buybid_auction
    when BuybidCommon::BusinessNames::SHOP
      Spree::Taxon.buybid_shop
    when BuybidCommon::BusinessNames::PARTNER
      Spree::Taxon.buybid_partner
    when BuybidCommon::BusinessNames::STORE
      Spree::Taxon.buybid_store
    else
      Spree::Taxon.all
    end

    return @taxons.ransack(@params[:q]).result unless @params[:q].blank?

    @taxons
  end
end
