require 'open-uri'

module Markets
  class ProductCardsFetch
    def initialize(queue_name)
      @queue_name = queue_name
    end

    def exchange
      BuybidCommon::Queues::MarketsQueue.fetch_exchange(:fanout, @queue_name)
    end

    def queue
      puts "queue_name 1: #{@queue_name}"
      @queue ||= BuybidCommon::Queues::MarketsQueue.fetch_queue(@queue_name).bind(exchange)
    end

    def execute
      Rails.logger.info 'ProductCardsFetch start'

      ActiveRecord::Base.connection_pool.with_connection do
        queue.subscribe(block: true) do |delivery_info, properties, payload|
          Rails.logger.info 'ProductFetch begin'
          begin
            on_product(JSON.parse(payload))
          rescue => e
            Rails.logger.fatal "ProductCardsFetch exception: #{e.message}"
            Rails.logger.fatal e.backtrace.join("\n")
            Raven.capture_exception(e)
          end
        end
      end
      
      Rails.logger.info 'ProductCardsFetch end'
    end

    def on_product(search_result)
    	Rails.logger.info "      - Fetch product cards [#{search_result[:products].count}]..."
      
      seller_ids_map = {}

      search_result[:sellers].each do |seller_card|
        seller = create_seller(seller_card)
        seller_ids_map[seller_card[:seller_code]] = seller.id
      end
      
      search_result[:products].each do |product_card|
        product_attrs = product_card[:attributes]

        option_values = []
        option_type_ids = []

        product_card[:option_values].each do |option_name|
          option_value = Spree::OptionValue.where(name: option_name).first
          option_values.push(option_value) if option_value.present?
          option_type_ids.push(option_value.option_type_id)
        end

        buybid_categories = Spree::Taxon.where(id: product_card[:buybid_category_ids])
        taxon_ids = buybid_categories.map { |buybid_category| buybid_category.id }

        product = Buybid::Product::Create.new(
          product_attrs.merge(option_type_ids: option_type_ids, taxon_ids: taxon_ids, buybid_seller_id: seller_ids_map[product_card[:seller_code]]),
          {
            variants_attrs: [{ price: product_attrs[:price], currency: product_attrs[:currency] }],
            options_attrs: []
          }).execute

        properties = product_card[:properties]

        properties.each do |property|
          product.set_property(property[:name], property[:value])
        end

        sku = "BB02-#{product.id.to_s.rjust(9, "0")}"

        product.master.update!({
          sku: sku,
          price: product_attrs[:price],
          currency: product_attrs[:currency],
          cost_price: product_attrs[:price],
          cost_currency: product_attrs[:currency],
          option_values: option_values
        })

        image_options = save_image(product[:buybid_market_name], product_card[:image_url], product[:id], 'products')
        
        product.master.images.create!(attachment: { 
          io: File.open(image_options[:buybid_image_path_full]), 
          filename: "#{image_options[:image_name]}.#{image_options[:image_type]}"
        })

        country =  Spree::Country.find_by(iso: 'JP')
        location = Spree::StockLocation.first_or_create!(name: 'default',
                                                        address1: '123 Tokyo Str',
                                                        city: 'Tokyo',
                                                        zipcode: '12345',
                                                        country: country,
                                                        state: country.states.first)
        location.active = true
        location.save!

        Spree::Variant.where(product_id: product.id).each do |variant|
          variant.stock_items.each do |stock_item|
              Spree::StockMovement.create(quantity: 10, stock_item: stock_item)
          end
        end
      end
    end

    def create_seller(seller_card)
      seller_attributes = seller_card[:attributes]
      seller = Buybid::Seller::Create.new(seller_attributes).execute

      if seller_card[:image_url].present?
        image_options = save_image(seller_card[:buybid_market_name], seller_card[:image_url], seller[:id], 'sellers')

        seller.spree_images.create!(attachment: {
          io: File.open(image_options[:buybid_image_path_full]),
          filename: "#{image_options[:image_name]}.#{image_options[:image_type]}"
        })
      end

      seller
    end

    def save_image(buybid_market_name, image_url, id, folder_path)
      return unless image_url.present?
      
      image_name = "#{buybid_market_name}_#{id}"
      image_type = "png"
      buybid_image_path_full = "storage/#{buybid_market_name}/#{folder_path}/#{image_name}.#{image_type}"

      FileUtils.mkdir_p(File.dirname(buybid_image_path_full)) unless Dir.exists?(File.dirname(buybid_image_path_full))

      Rails.logger.info "#{buybid_image_path_full} << #{image_url}"

      open(buybid_image_path_full, 'wb') do |file|
        file << open(image_url).read
      end

      {
        image_name: image_name,
        image_type: image_type,
        buybid_image_path_full: buybid_image_path_full
      }
    end

    def image(name, type = 'jpeg')
      images_path = Pathname.new(File.dirname(__FILE__)) + 'images'
      path = images_path + file_name(name, type)
      return false unless File.exist?(path)

      File.open(path)
    end

    def file_name(name, type = 'jpeg')
      "#{name}.#{type}"
    end

    def attach_paperclip_image(variant, name, type)
      if variant.images.where(attachment_file_name: file_name(name, type)).none?
        image = image(name, type)
        variant.images.create!(attachment: image)
      end
    end

    def attach_active_storage_image(variant, name, type)
      if variant.images.with_attached_attachment.where(active_storage_blobs: { filename: file_name(name, type) }).none?
        image = image(name, type)
        variant.images.create!(attachment: { io: image, filename: file_name(name, type) })
      end
    end    
  end
end
