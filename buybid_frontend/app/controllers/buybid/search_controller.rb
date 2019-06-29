module Buybid
  class SearchController < ApplicationController
    before_action :prepare_view_path, only: [:index]
    layout 'spree_application'

    def index
      @categories = categories
      @brands = brands
      @tags = tags
      @search_params = search_params
      @search_params_to_s = search_params_to_s
      render 'search/index.html'
    end  

    private
  
    def categories
      @categories ||= Spree::Taxonomy.find_by(name: 'categories').taxons.limit(10)
    end

    def brands
      @brands ||= Spree::Taxonomy.find_by(name: 'brands').taxons.limit(10)
    end

    def tags
      @tags = whitelisted_params.
        except(
          :format, 
          :action, 
          :controller, 
          :page, 
          :per_page
        ).
        to_h
      @tags[:current_price] = [@tags[:current_price_from], @tags[:current_price_to]] if @tags[:current_price_from].present?
      @tags[:buynow_price] = [@tags[:buynow_price_from], @tags[:buynow_price_to]] if @tags[:buynow_price_from].present?
      @tags.delete(:current_price_from)
      @tags.delete(:current_price_to)
      @tags.delete(:buynow_price_from)
      @tags.delete(:buynow_price_to)
      @tags
    end

    # Search params for api call  
    def search_params
      @search_params = whitelisted_params. 
        to_h.
        except(:format, :action, :controller, :page, :per_page)
    end

    def search_params_to_s
      search_params.
        map{|key,val| "#{key}=#{val}"}.
        join('&')
    end

    def whitelisted_params
      @whitelisted_params ||= params.permit(
        :business,
        :product_code,
        :seller_code,
        :brand, 
        :category, 
        :product_price, 
        :expire_in, 
        :product_status, 
        :seller_type, 
        :freeship, 
        :sort,
        :current_price_from,
        :current_price_to,
        :buynow_price_from,
        :buynow_price_to
      )
    end

    def prepare_view_path
		  prepend_view_path SpreeBuybidThemesBuybid1st::Engine.root.join('app', 'views', 'spree')
    end

  end
end
