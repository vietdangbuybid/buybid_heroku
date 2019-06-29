class Elasticsearch::Product::Search

  def initialize(params: nil)
    @name = params[:q].present? ? params[:q] : "" 
    @business = 'buybid_' << params[:business] if params[:business].present?
    @trends = trends(params[:trend], params[:include_trends], params[:exclude_trends])
    @brand_permalink = params[:brand].present? ? params[:brand] : "" 
    @taxon_id = params[:taxon_id].present? ? params[:taxon_id] : "" 
    @id = params[:id].present? ? params[:id] : "" 
    @buybid_product_code = params[:product_code].present? ? params[:product_code] : ""
    @seller_code = params[:seller_code].present? ? params[:seller_code] : ""

    @brand_name = params[:brand].present? ? params[:brand].split('+').join(' ') : ""
    @category_name = params[:category].present? ? params[:category].split('+').join(' ') : ""

    @current_price_from = params[:current_price_from].present? ? params[:current_price_from].to_i : 0 
    @current_price_to = params[:current_price_to].present? ? params[:current_price_to].to_i : 0 

    @buynow_price_from = params[:buynow_price_from].present? ? params[:buynow_price_from].to_i : 0 
    @buynow_price_to = params[:buynow_price_to].present? ? params[:buynow_price_to].to_i : 0 

    @expire_in = params[:expire_in].present? ? params[:expire_in] : ""

    @product_status = params[:product_status].present? ? params[:product_status] : ""
    @seller_type = params[:seller_type].present? ? params[:seller_type] : ""
    @freeship_option = params[:freeship].present? ? params[:freeship] : ""

    @sort = params[:sort].present? ? params[:sort] : ""
  end

  def execute(page, per_page)
    response = Spree::Product.__elasticsearch__.
      search(products_query).
      page(page).
      per(per_page)
    response.results
  end

  private
  def trends(trend, include_trends, exclude_trends)
    @trends = []
    @include_trends = []
    @exclude_trends = []

    @trends = @trends << ('buybid_' << trend) unless trend.nil?
    @trends = @trends + include_trends.to_a.map{|trend| 'buybid_' << trend} unless include_trends.nil?
    @trends = @trends + (['hot','new', 'popular'] - exclude_trends.to_a).map{|trend| 'buybid_' << trend} unless exclude_trends.nil?

    @trends

  end

  # ToSo: Implement sorting later
  def products_query
    products_query = [] 
    product_sort_query = []
    products_query += @trends.map {|trend| {match: {trend => 1}}} 
    products_query << {match: {:name => @name}} unless @name.empty? 
    products_query << {match: {@business => 1}} unless @business.nil?
    products_query << expire_in_query(@expire_in) unless @expire_in.empty? 
    products_query << {match: {@trend => 1}} unless @trend.nil?
    products_query << {match: {:id => @id}} unless @id.empty?
    products_query << brand_query(@brand_name) unless @brand_name.empty?
    products_query << category_query(@category_name) unless @category_name.empty?
    products_query << {match: {'buybid_seller.seller_code' => @seller_code}} unless @seller_code.empty?
    products_query << {match: {:buybid_product_code => @buybid_product_code}} unless @buybid_product_code.empty?     
    products_query << {match: {'shipping_category.name' => @freeship_option}} unless @freeship_option.empty?

    products_query << {match: {:buybid_new => product_status_query(@product_status)}} unless @product_status == 'all' || @product_status.empty?
    products_query << seller_type_query(@seller_type) unless @seller_type.empty? || @seller_type == 'all'

    products_query << current_price_query(@current_price_from, @current_price_to) unless @current_price_from ==0 && @current_price_to == 0
    # Todo: Handle buynow price  
    #products_query << buynow_price_query(@buynow_price_from, @buynow_price_to) unless @buynow_price_from == 0 && @buynow_price_to == 0

    product_sort_query << sort_query(@sort) unless @sort.empty? || sort_query(@sort).nil?

    {
      _source: [
        :id,
        :name,
        :description,
        :buybid_product_code,
        :displayed_price,
        :formatted_price,
        :available_on, 
        :slug, 
        :total_on_hand, 
        :buybid_auction, 
        :buybid_shop, 
        :buybid_partner, 
        :buybid_hot, 
        :buybid_new, 
        :buybid_store, 
        :in_stock, 
        :buybid_seller, 
        :created_at,
        :current_price,
        :buynow_price,
        :discontinue_on,
        :brand_names,
        :category_names,
        :shipping_category,
        :image, 
      ],
      query: {
        bool: {
          must: products_query
        }
      },
      sort: product_sort_query
    }
  end

  def product_status_query(val)
    case val
    when 'new'
      1
    when 'used'
      0
    end
  end


  def sort_query(val)
    case val 
    when 'created_at_asc'
      {created_at: {order: :asc}}
    when 'created_at_desc'
      {created_at: {order: :desc}}
    when 'discontinue_on_asc' 
      {discontinue_on: {order: :asc}}
    when 'discontinue_on_desc'
      {discontinue_on: {order: :desc}}
    when 'price_desc'
      {formatted_price: {order: :desc}}
    when 'price_asc'
      {formatted_price: {order: :asc}}
    else 
      return nil 
    end
    # Will handle bids and price later
  end

  def category_query(cat_name)
    {
      bool: {
        must: {
          term: {
            category_names: cat_name.downcase
          }
        }
      }
    }
  end

  def brand_query(brand_name)
    {
      bool: {
        must: {
          term: {
            brand_names: brand_name.downcase
          }
        }
      }
    }
  end

  def expire_in_query(time)
    {
      range: {
        discontinue_on: {
          gte: DateTime.now.to_datetime,
          lte: expected_expire_in(time),
          boost: 2.0
        }
      }
    }
  end

  # Currently will search the formatted price
  def current_price_query(from, to)
    {
      range: {
        formatted_price: {
          gte: from,
          lte: to,
          boost: 2.0
        }
      }
    }
  end

  def buynow_price_query(from, to)
    {
      range: {
        buynow_price: {
          gte: from,
          lte: to,
          boost: 2.0
        }
      }
    }
  end

  # If seller_type is all, then return nothing 
  def seller_type_query(seller_type) 
    case seller_type
    when 'shop'
      {match: {'buybid_seller.shop' => 1}}
    when 'individual'
      {match: {'buybid_seller.individual' => 1}}
    end
  end

  def expected_expire_in(time)
    current_time = DateTime.now.to_time
    case time
    when "1h"
      return (current_time + 1.hour).to_datetime
    when "2h"
      return (current_time + 2.hours).to_datetime
    when "3h"
      return (current_time + 3.hours).to_datetime
    when "6h"
      return (current_time + 6.hours).to_datetime
    when "12h"
      return (current_time + 12.hours).to_datetime
    when "1d"
      return (current_time + 24.hours).to_datetime
    when "2d"
      return (current_time + 48.hours).to_datetime
    when "3d"
      return (current_time + 96.hours).to_datetime
    when "5d"
      return (current_time + 120.hours).to_datetime
    end
  end

end
