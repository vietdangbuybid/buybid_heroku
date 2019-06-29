class Buybid::Product::Search < Buybid::Product::Abstract
  def initialize(params)
    super()
    @params = params
  end

  def execute
    @products = Spree::Product.spree_base_scopes.
      not_deleted.
      available.
      left_joins(:buybid_seller);
    if @params[:business].present?
      @products = case @params[:business]
      when BuybidCommon::BusinessNames::AUCTION
        @products.buybid_auction
      when BuybidCommon::BusinessNames::SHOP
        @products.buybid_shop
      when BuybidCommon::BusinessNames::PARTNER
        @products.buybid_partner
      when BuybidCommon::BusinessNames::STORE
        @products.buybid_store
      else
        @products
      end
    end

    if @params[:exclude_trends].present?
      exclude_trends = @params[:exclude_trends]
      unless exclude_trends.is_a? Array
        exclude_trends = [ exclude_trends ]
      end
      exclude_trends.each do |exclude_trend|
        @products = case exclude_trend
        when BuybidCommon::TrendNames::HOT
          @products.not_buybid_hot
        when BuybidCommon::TrendNames::NEW
          @products.not_buybid_new
        when BuybidCommon::TrendNames::POPULAR
          @products.not_buybid_popular
        else
          @products
        end
      end
    end

    if @params[:include_trends].present?
      include_trends_terms = []
      include_trends = @params[:include_trends]
      unless include_trends.is_a? Array
        include_trends = [ @params[:include_trends] ]
      end
      include_trends.each do |exclude_trend|
        if exclude_trend == BuybidCommon::TrendNames::HOT
          include_trends_terms << Spree::Product.buybid_hot
        elsif exclude_trend == BuybidCommon::TrendNames::NEW
          include_trends_terms << Spree::Product.buybid_hot
        elsif exclude_trend == BuybidCommon::TrendNames::POPULAR
          include_trends_terms << Spree::Product.buybid_popuplar
        end
      end
      include_trends_terms_combined = nil
      include_trends_terms.each do |include_trends_term|
        if include_trends_terms_combined.nil?
          include_trends_terms_combined = include_trends_term
        else
          include_trends_terms_combined = include_trends_terms_combined.or(include_trends_term)
        end
      end
      @products = @products.where(include_trends_terms_combined) unless include_trends_terms_combined.nil?
    end

    if @params[:trend].present?
      @products = case @params[:trend]
      when BuybidCommon::TrendNames::HOT
        @products.buybid_hot
      when BuybidCommon::TrendNames::NEW
        @products.buybid_new
      else
        @products
      end
    end

    if @params[:brand].present?
      @products = @products.in_taxon(Spree::Taxon.find_by(:permalink => @params[:brand]))
    end

    if @params[:taxon_id].present?
      @products = @products.in_taxon(Spree::Taxon.find(@params[:taxon_id]))
    end

    unless @params[:ids].blank?
      @products = @products.where(id: @params[:ids].split(',').flatten)
    end

    if @params[:q]
      @products = @products.ransack(@params[:q]).result
    end
    @products.distinct
  end
end
