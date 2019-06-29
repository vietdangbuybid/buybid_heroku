module SpreeBuybidApi
  module ApiProductsControllerDecorator
    def index
      if params[:business].present? || params[:trend].present? || params[:brand].present?

        @products = Elasticsearch::Product::Search.new({params: params}).
          execute(params[:page], params[:per_page])

        expires_in ENV['HOME_API_PRODUCTS_INDEX_CACHE_MINUTES'].to_i.minutes, public: true
        headers['Surrogate-Control'] = "max-age=#{ENV['HOME_API_PRODUCTS_INDEX_CACHE_MINUTES'].to_i.minutes}"

        respond_with(@products, default_template: 'buybid/api/products/index_hash', status: 200)
      else
        @products = if params[:ids]
          product_scope.where(id: params[:ids].split(',').flatten)
        else
          product_scope.ransack(params[:q]).result
        end
        @products = @products.distinct.page(params[:page]).per(params[:per_page])

        @products = Elasticsearch::Product::Search.new({params: params}).
          execute(params[:page], params[:per_page])

        expires_in 15.minutes, public: true
        headers['Surrogate-Control'] = "max-age=#{15.minutes}"
        respond_with @products, default_template: 'buybid/api/products/index_hash', status: 200
      end
    end


  end
end

Spree::Api::V1::ProductsController.prepend SpreeBuybidApi::ApiProductsControllerDecorator
