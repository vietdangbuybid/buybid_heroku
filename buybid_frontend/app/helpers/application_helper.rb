# frozen_string_literal: true

module ApplicationHelper
  BUSINESS_URL_PREFIX = "/"

  def main_app
    Rails.application.class.routes.url_helpers
  end

  def auction_url
    BUSINESS_URL_PREFIX + BuybidCommon::BusinessNames::AUCTION
  end

  def partner_url
    BUSINESS_URL_PREFIX + BuybidCommon::BusinessNames::PARTNER
  end

  def shop_url
    BUSINESS_URL_PREFIX + BuybidCommon::BusinessNames::SHOP
  end

  def buybidshop_url
    BUSINESS_URL_PREFIX + 'buybidshop'
  end

  def public_statics_assets_root
    @public_statics_assets_root ||= ENV['BUYBID_FRONTEND_PUBLIC_STATICS_ASSETS_ROOT']
  end

  def format_filtered_tag(tag_val)
    if tag_val.kind_of?(Array) 
      tag_val.join('->').to_s;
    else
      tag_val
    end
  end

  def search_category_checked?(cat_name)
    return true if @search_params[:category] == cat_name
    false
  end

  def search_brand_checked?(brand_name)
    return true if @search_params[:brand] == brand_name
    false
  end

  def theme_root
    SpreeBuybidThemesBuybid1st::Engine.root.join('app', 'views', 'theme')
  end

end
