module Buybid
  class Seller < Spree::Base

    attr_accessor :visible, :popular
    self.table_name = 'buybid_sellers'
    has_many :spree_images, class_name: 'Spree::Image', as: :viewable, dependent: :destroy

    has_one :buybid_seller_logo, class_name: 'Buybid::SellerLogo', foreign_key: :buybid_seller_id
    has_one :spree_image, class_name: 'Spree::Image', through: :buybid_seller_logo, foreign_key: :buybid_seller_id

    has_many :spree_products, class_name: 'Spree::Product', foreign_key: :buybid_seller_id
    has_many :spree_addresses, class_name: 'Spree::Address', foreign_key: :buybid_seller_id

    has_many :seller_classifications, class_name: 'Buybid::SellerClassification', foreign_key: :buybid_seller_id

    has_many :spree_taxons, class_name: 'Spree::Taxon', through: :seller_classifications, foreign_key: :buybid_seller_id

    belongs_to :main_category, class_name: 'Spree::Taxon'

    validates :name, presence: true, length: { maximum: 250 }
    validates :description, presence: false, length: { minimum: 0, maximum: 1000 }
    validates :phone_number, length: { maximum: 20 }
    validates :position, numericality: true, length: { maximum: 1_000_000 }
    validates :URL, presence: true, length: { maximum: 256 }
    validates :order_count, numericality: true
    validates :address, presence: false, length: { minimum: 0, maximum: 1000 }
    validates :account_code, presence: true, if: :auction?
    with_options if: :check_type? do
      validates :auction, presence: BuybidCommon::BusinessValues::AUCTION
      validates :shop, presence: BuybidCommon::BusinessValues::SHOP
      validates :partner, presence: BuybidCommon::BusinessValues::PARTNER
    end
    validates :main_category_id, presence: true

    scope :auction, -> { where(auction: BuybidCommon::BusinessValues::AUCTION) }
    scope :not_auction, -> { where(auction: [nil, BuybidCommon::BusinessValues::NOT_AUCTION]) }

    scope :shop, -> { where(shop: BuybidCommon::BusinessValues::SHOP) }
    scope :not_shop, -> { where(shop: [nil, BuybidCommon::BusinessValues::NOT_SHOP]) }

    scope :partner, -> { where(partner: BuybidCommon::BusinessValues::PARTNER) }
    scope :not_partner, -> { where(partner: [nil, BuybidCommon::BusinessValues::NOT_PARTNER]) }

    scope :popular, -> { where(popular: BuybidCommon::TrendValues::POPULAR) }
    scope :not_popular, -> { where(popular: [nil, BuybidCommon::TrendValues::NOT_POPULAR]) }

    scope :visible, -> { where.not(visible: false, is_deleted: true) }
    scope :not_visible, -> { where.not(visible: true, is_deleted: true) }

    scope :deleted, -> { where(is_deleted: true) }
    scope :not_deleted, -> { where.not(is_deleted: true) }

    scope :sort_by_position_desc, lambda { order("position DESC") }
    scope :sort_by_position_asc, lambda { order("position ASC") }

    scope :list_category, ->{ Spree::Taxon.where(parent_id: 1) }

    # When delete a seller, does not erase it directly from a database. Rather, mark the is_deleted flag as true
    def mark_as_deleted
      update_attribute(:is_deleted, true)
    end

    def restore
      update_attribute(:is_deleted, false)
    end

    def get_contacts
      spree_addresses.all
    end

    def update_category(cat_ids)
      spree_taxons.clear
      unless cat_ids.nil?
        cat_ids_arr = cat_ids.split(',')
        cat_ids_arr.each do |cat_id|
          taxon = Spree::Taxon.find(cat_id)
          spree_taxons.append(taxon)
        end
      end
    end

    def set_main_category_id(main_cat_id)
      spree_taxons << Spree::Taxon.find(main_cat_id)
      if update_attribute(:main_category_id, main_cat_id)
        Rails.logger.info 'Success!'
      else
        Rails.logger.info errors.full_messages
      end
    end

    # Create a new category name for seller
    def create_category(cat_name)
      category = Spree::Taxonomy.where(name: 'Categories').first
      category = Spree::Taxonomy.create(name: 'Categories') if category.nil?
      taxon = Spree::Taxon.find_by(name: cat_name, taxonomy_id: category.id)
      if taxon.present?
        spree_taxons.append(taxon)
      else
        taxon = Spree::Taxon.new(name: cat_name, taxonomy_id: category.id, parent_id: category.root.id)
        if taxon.save
          spree_taxons.append(taxon)
        else
          Rails.logger.info "Error! #{taxon.errors.full_messages}"
        end
      end
    end

    def categories
      spree_taxons.where(taxonomy_id: Spree::Taxonomy.where(name: 'Categories').first.id)
    end

    def category_taxon_ids
      spree_taxons.where(taxonomy_id: Spree::Taxonomy.where(name: 'Categories').first.id).pluck(:id)
    end

    def set_logo(attachment)
      return true if Buybid::Seller.valid_attachment_type?(attachment, self)
      new_logo = Spree::Image.new(attachment_file_name: "Logo of #{name}", attachment: attachment)
      if new_logo.save
        spree_images << new_logo
        self.spree_image = new_logo
        Rails.logger.info 'Success!'
        return true
      else
        Rails.logger.info "Failture! #{new_logo.errors.full_messages} "
        return false
      end
    end


    def set_type(auction, shop, partner, store)
      update_attribute(:auction, BuybidCommon::BusinessValues::AUCTION) if auction == 1
      update_attribute(:shop, BuybidCommon::BusinessValues::SHOP) if shop == 1
      update_attribute(:partner, BuybidCommon::BusinessValues::PARTNER) if partner == 1
      update_attribute(:store, BuybidCommon::BusinessValues::STORE) if store == 1
    end

    def set_visible_and_popular(visible, popular)
      visible = visible == '1'
      popular = popular == '1'
      toggle(:visible) if visible? ^ visible
      toggle(:popular) if popular? ^ popular
      save
    end

    def self.valid_attachment_type?(attachment, seller)
      return true if attachment.nil?

      valid_content_type = %w[jpeg png jpg]
      ext = File.extname(attachment.original_filename)
      if valid_content_type.include? ext[1..-1]
        false
      else
        seller.errors.add(:logo_id, :blank, message: 'only jpeg, png and jpg are allowed!')
        true
      end
    end


    private
    def logo_already_exists?
      self.spree_image.present?
    end

    def check_type?
      !(auction? || partner? || shop?)
    end
  end
end

