module Buybid::Api::Buybid
  class SellersController < Spree::Api::BaseController
    def index
      @sellers = Buybid::Seller::Search.new(params).execute.
        includes(:spree_image, :main_category).
        page(params[:page]).per(params[:per_page])

      expires_in ENV['HOME_API_SELLERS_INDEX_CACHE_MINUTES'].to_i.minutes, public: true
      headers['Surrogate-Control'] = "max-age=#{ENV['HOME_API_SELLERS_INDEX_CACHE_MINUTES'].to_i.minutes}"
      respond_with(@sellers, default_template: 'buybid/api/sellers/index', status: 200)
    end
  end
end
