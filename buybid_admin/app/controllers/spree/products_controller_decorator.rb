module BuybidAdmin
  module ProductsControllerDecorator
    def new
      @product = Spree::Product.new
    end

    def create
      @product = Spree::Product.create(product_params)
      @product.taxon_ids = params[:product][:taxon_ids].split(',')

      @product.slug = "#{product_params[:name].to_url}-#{@product.id}"

      respond_with(@product) do |format|
        if @product.save
          @product.variants.create({
            product: @product,
            price: @product[:price],
            currency: current_currency
          })

          if product_params[:sku].empty?
            @product.master.update!(sku: "BB02-#{@product.id.to_s.rjust(9, '0')}")
          end

          save_logo(@product, params[:product][:logo])
          save_images(@product, params[:product][:attachment])
          
          if params[:continue].present? && !params[:continue].empty?
            format.html { redirect_to edit_admin_product_path(@product) }
          else
            format.html { redirect_to admin_products_path }
          end
        else
          flash[:error] = @product.errors.full_messages

          format.html { render :new }
        end
      end
    end

    def edit
      @product = Spree::Product.where(slug: params[:id]).first
    end

    def update
      @product = Spree::Product.where(slug: params[:product][:slug]).first
      @product.update_attributes(product_params)
      @product.update_attribute(:slug, "#{product_params[:name].to_url}-#{@product.id}")
      @product.taxon_ids = params[:product][:taxon_ids].split(',')
      
      if product_params[:sku].empty?
        @product.master.update!(sku: "BB02-#{@product.id.to_s.rjust(9, '0')}")
      end

      save_logo(@product, params[:product][:logo])
      save_images(@product, params[:product][:attachment])

      respond_with(@product) do |format|
        if @product.save
          if params[:continue].present? && !params[:continue].empty?
            format.html { redirect_to edit_admin_product_path(@product) }
          else
            format.html { redirect_to admin_products_path }
          end
        else
          format.html { render :edit }
        end
      end
    end

    def load_data
      super
      @buybid_sellers = Buybid::Seller.order(:name)
    end

    def toggle_visible
      @product.toggle(:buybid_visible)

      respond_to do |format|
        if @product.save
          format.html { redirect_to admin_products_path(@list_type), notice: "Product #{@product.name}'s visibility is now set to #{@product.buybid_visible?}" }
        else
          flash[:error] = "Product #{@product.name} failed to set buybid_visible to #{!@product.buybid_visible}. Error: #{@product.errors.full_messages}"
          format.html { redirect_to admin_products_path(@list_type) }
        end
      end
    end

    def toggle_popular
      @product.toggle(:buybid_popular)

      respond_to do |format|
        if @product.save
          format.html { redirect_to admin_products_path(@list_type), notice: "Product #{@product.name}'s buybid_popularity is now set to #{@product.buybid_popular?}" }
        else
          flash[:error] = "Product #{@product.name} failed to set buybid_popular to #{!@product.buybid_popular}. Error: #{@product.errors.full_messages}"
          format.html { redirect_to admin_products_path(@list_type) }
        end
      end
    end

    def collection
      return @collection if @collection.present?

      params[:q] ||= {}
      params[:q][:buybid_visible] ||= '0'
      params[:q][:buybid_popular] ||= '0'
      params[:q][:taxon_id] ||= nil
      params[:q][:s] ||= 'updated_at desc'

      @collection = super
      # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
      # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
      #if params[:q][:deleted_at_null] == '0'
      #@collection = @collection.with_deleted
      #end
      # @search needs to be defined as this is passed to search_form_for
      # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
      # This is to include all products and not just deleted products.
      
      if params[:q][:buybid_visible] == '2'
        @collection = @collection.buybid_visible
      elsif params[:q][:buybid_visible] == '3'
        @collection = @collection.not_buybid_visible
      end

      if params[:q][:buybid_popular] == '2'
        @collection = @collection.buybid_popular
      elsif params[:q][:buybid_popular] == '3'
        @collection = @collection.not_buybid_popular
      end
      
      if params[:q][:taxon_id].present?
        @collection = @collection.in_taxon(Spree::Taxon.find(params[:q][:taxon_id]))
      end
      
      if params[:q][:buybid_seller_id].present?
        @collection = @collection.where(buybid_seller_id: params[:q][:buybid_seller_id])
      end
      
      if params[:q][:business] == '2'
        @collection = @collection.buybid_auction
      elsif params[:q][:business] == '3'
        @collection = @collection.buybid_shop
      elsif params[:q][:business] == '4'
        @collection = @collection.buybid_partner
      elsif params[:q][:business] == '5'
        @collection = @collection.buybid_store
      end      

      @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' }).
        result.includes(product_includes).
        page(params[:page]).
        per(params[:per_page] || Spree::Config[:admin_products_per_page])

      @collection
    end

    private

    def product_params
      params.require(:product).permit(permitted_product_attributes + [
        :buybid_auction,
        :buybid_shop,
        :buybid_partner,
        :buybid_store,
        :buybid_hot,
        :buybid_new,
        :buybid_popular,
        :buybid_seller_id,
        :buybid_url_original,
        :buybid_position,
        :buybid_visible,
        :taxon_ids,
        :meta_title
      ])
    end

    def save_logo(product, attachment)
      if attachment.present?
        product_image = Spree::Image.create({
          attachment_file_name: attachment.original_filename,
          attachment: attachment,
          viewable: @product.master,
          position: 1
        })
        
        product.images << product_image
      end
    end

    def save_images(product, attachments)
      if attachments.present? && !attachments.empty?
        attachments.each do |attachment|
          product_image = Spree::Image.create({
            attachment_file_name: attachment.original_filename,
            attachment: attachment,
            viewable: @product.master
          })

          product.images << product_image
        end
      end
    end

  end
end

Spree::Admin::ProductsController.prepend BuybidAdmin::ProductsControllerDecorator
