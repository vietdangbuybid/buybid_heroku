require 'elasticsearch/model'
module Buybid 
  module ProductDecorator
    def self.prepended(base)
      base.belongs_to :buybid_seller, class_name: 'Buybid::Seller'
      base.whitelisted_ransackable_attributes = %w[description name slug available_on discontinue_on]

      base.include Elasticsearch::Model
      base.include Elasticsearch::Model::Callbacks

      base.scope :buybid_auction, -> { where(buybid_auction: BuybidCommon::BusinessValues::AUCTION) }
      base.scope :not_buybid_auction, -> { where(buybid_auction: BuybidCommon::BusinessValues::NOT_AUCTION) }

      base.scope :buybid_shop, -> { where(buybid_shop: BuybidCommon::BusinessValues::SHOP) }
      base.scope :not_buybid_shop, -> { where(buybid_shop: BuybidCommon::BusinessValues::NOT_SHOP) }

      base.scope :buybid_partner, -> { where(buybid_partner: BuybidCommon::BusinessValues::PARTNER) }
      base.scope :not_buybid_partner, -> { where(buybid_partner: BuybidCommon::BusinessValues::NOT_PARTNER) }

      base.scope :buybid_store, -> { where(buybid_store: BuybidCommon::BusinessValues::STORE) }
      base.scope :not_buybid_store, -> { where(buybid_store: BuybidCommon::BusinessValues::NOT_STORE) }

      base.scope :buybid_hot, -> { where(buybid_hot: BuybidCommon::TrendValues::HOT) }
      base.scope :not_buybid_hot, -> { where(buybid_hot: BuybidCommon::TrendValues::NOT_HOT) }

      base.scope :buybid_new, -> { where(buybid_new: BuybidCommon::TrendValues::NEW) }
      base.scope :not_buybid_new, -> { where(buybid_new: BuybidCommon::TrendValues::NOT_NEW) }

      base.scope :buybid_popular, -> { where(buybid_popular: BuybidCommon::TrendValues::POPULAR) }
      base.scope :not_buybid_popular, -> { where(buybid_popular: BuybidCommon::TrendValues::NOT_POPULAR) }

      base.scope :buybid_visible, -> { where(buybid_visible: true) }
      base.scope :not_buybid_visible, -> { where(buybid_visible: false) }

      base.scope :sort_by_buybid_position_desc, lambda { order("buybid_position DESC") }
      base.scope :sort_by_buybid_position_asc, lambda { order("buybid_position ASC") }

      base.scope :buybid_popular, -> { where(buybid_popular: BuybidCommon::BusinessValues::POPULAR) }
      base.scope :not_buybid_popular, -> { where(buybid_popular: BuybidCommon::BusinessValues::NOT_POPULAR) }

      # Setting the index names and document types for elasticsearch 
      base.index_name 'spree_products'
      base.document_type 'spree_products'

      # How the whole table will be indexed  
      base.settings index: {number_of_shards: 1} do 
        mappings dynamic: 'false' do
          indexes :id, type: :keyword
          indexes :name, type: :text 
          indexes :description, type: :text

          indexes :available_on, type: :date
          indexes :slug, type: :text
          indexes :total_on_hand, type: :long
          indexes :discontinue_on, type: :date
          indexes :created_at, type: :date


          indexes :buybid_seller, type: 'nested' do
            indexes :id, type: :keyword
            indexes :name, type: :text
            indexes :seller_code, type: :keyword
            indexes :individual, type: :keyword
            indexes :description, type: :text
            indexes :rating_point, type: :double
            indexes :order_count, type: :long
            indexes :URL, type: :text
            indexes :auction, type: :boolean
            indexes :shop, type: :boolean
            indexes :partner, type: :boolean
            indexes :store, type: :boolean
            indexes :popular, type: :boolean
            indexes :position, type: :keyword 
            indexes :visible, type: :boolean
            indexes :created_at, type: :date

            indexes :spree_image, type: 'nested' do
              indexes :id, type: :keyword
              indexes :alt, type: :keyword
              indexes :product_url, type: :keyword, :as => :product_url
            end

          end

          indexes :image, type: 'nested' do
            indexes :id, type: :keyword  
            indexes :alt, type: :keyword
            indexes :product_url, type: :text, :as => :product_url 
          end

          indexes :shipping_category, type: 'nested' do
            indexes :id, type: :keyword
            indexes :name, type: :keyword
          end

          indexes :category_names, as: :category_names

          indexes :formatted_price, type: :integer do
            indexes :keyword, type: 'integer' 
          end

          indexes :brand_names, as: :brand_names
          indexes :display_price, as: :displayed_price

          indexes :buynow_price, as: :buynow_price
          indexes :current_price, as: :current_price

          indexes :buybid_headline, type: :keyword
          indexes :buybid_auction, type: :keyword
          indexes :buybid_shop, type: :keyword
          indexes :buybid_partner, type: :keyword
          indexes :buybid_store, type: :keyword
          indexes :buybid_hot, type: :keyword
          indexes :buybid_new, type: :keyword 
          indexes :buybid_popular, type: :keyword
          indexes :buybid_market_name, type: :text
          indexes :buybid_product_code, type: :keyword
          #indexes :tax_category_id, type: :keyword
          #indexes :meta_title, type: :keyword
        end
      end
    end

    # How the db record will be structured 
    def as_indexed_json(options={})
      self.as_json(
        options.merge(
          only: [:id, :name, :description, :available_on, :slug, :total_on_hand, :buybid_auction, :buybid_shop, :buybid_partner, :buybid_store, :buybid_hot, :buybid_new, :buybid_popular, :buybid_market_name, :buybid_product_code, :buybid_headline, :discontinue_on, :created_at],
          methods: [:brand_names, :category_names, :formatted_price, :displayed_price, :buynow_price, :current_price],
          include: {
            buybid_seller: {
              only: [
                :id, :name, :individual, :seller_code, :phone_number, :description, :rating_point, :position, :order_count, :URL, :auction, :shop, :partner, :store, :popular, :visible, :created_at
              ],
              include: {
                spree_image: {
                  only: [:id, :alt],
                  methods: [:product_url]
                },
              }
            },
            image: {
              only: [:id, :alt],
              methods: [:product_url]
            },
            shipping_category: {
              only: [:id, :name]
            }
        })
      )
    end

    # Only used for rendering price json for elasticsearch 
    def formatted_price 
      price.to_i
    end

    def displayed_price
      display_price.to_s
    end

    def current_price
      prices.find_by(buybid_current: 1).amount.to_s unless prices.find_by(buybid_current: 1).nil?
    end

    def buynow_price
      prices.find_by(buybid_buynow: 1).amount.to_s unless prices.find_by(buybid_buynow: 1).nil?
    end

    def brand_names
      brand_taxonomy_id = Spree::Taxonomy.find_by(name: 'Brands').id
      self.taxons.where(taxonomy_id: brand_taxonomy_id).pluck(:name)
    end

    def category_names
      category_taxonomy_id = Spree::Taxonomy.find_by(name: 'Categories').id
      self.taxons.where(taxonomy_id: category_taxonomy_id).pluck(:name)
    end

    def image
      master_images.first
    end

  end
end

Spree::Product.prepend Buybid::ProductDecorator
