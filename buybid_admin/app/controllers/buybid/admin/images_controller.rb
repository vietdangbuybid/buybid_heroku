# frozen_string_literal: true

module Buybid
  module Admin
    class ImagesController < Spree::Admin::ResourceController
      before_action :set_seller, only: %i[show index create update new edit destroy set_logo]
      before_action :set_image, only: %i[show update seller_logo set_logo]
      before_action :set_list_type

      create.before :set_viewable
      update.before :set_viewable

      def index
        seller_id = @seller.id
        @images = @seller.spree_images.all
      end

      def new
        @image = Spree::Image.new
      end

      def show; end

      def update
        @image.update_attributes(image_params)
        @image.update_attribute(:attachment, params[:image][:attachment]) if params[:image][:attachment].present? && Buybid::Seller.valid_attachment_type?(params[:image][:attachment], @seller)
        respond_to do |format|
          if @image.save
            format.html { redirect_to admin_seller_images_path(@seller), notice: 'Image has been successfully updated!' }
          else
            flash[:error] = @seller.errors.full_messages
            format.html { redirect_to admin_seller_images_path(@seller)}
          end
        end
      end

      def create
        @image.update_attributes(image_params)
        @image.update_attribute(:attachment, params[:image][:attachment]) if params[:image][:attachment].present? && Buybid::Seller.valid_attachment_type?(params[:image][:attachment], @seller)
        respond_to do |format|
          if @image.save
            @seller.spree_images.append(@image)
            if @seller.spree_images.size == 1
              @seller.update_attribute(:logo_id, @image.id)
              @seller.save
            end
            format.html { redirect_to admin_seller_images_path(@seller), notice: 'Image has been successfully udpated!' }
          else
            flash[:error] = @seller.errors.full_messages
            format.html { redirect_to admin_seller_images_path(@seller)}
          end
        end
      end

      def set_logo
        @seller.spree_image = @image
        # Only one image
        respond_to do |format|
          if @seller.save
            format.html { redirect_to admin_seller_images_path(@seller, @image), notice: "Image #{@image.attachment_file_name} is sucessfully set as the main logo" }
          else
            format.html { redirect_to admin_seller_images_path(@seller, @image), notice: "Image #{@image.attachment_file_name} fails to be set as the main logo!" }
          end
        end
      end

      def edit; end

      def destroy
        respond_to do |format|
          if @image.destroy!
            @seller.update_attribute(:logo_id, nil) if @seller.logo_id == @image.id
            format.html { redirect_to admin_seller_images_path(@seller), notice: 'Image has been successfully deleted!' }
          else
            format.html { redirect_to admin_seller_images_path(@seller), error: "Image cannot be deleted! #{@image.errors.full_messages}" }
          end
        end
      end

      private

      def seller_params
        params.require(:seller).permit(:name, :description, :order_count, :auction, :shop, :partner, :store)
      end

      def set_seller
        @seller = Buybid::Seller.find(params[:seller_id])
      end

      def set_image
        @image = Spree::Image.find(params[:image_id])
      end

      def image_params
        params.require(:image).permit(:attachment, :description, :attachment_file_name)
      end

      def set_viewable
        @image.viewable_type = 'Buybid::Seller'
        @image.viewable_id = @seller.id
      end

      def set_list_type
        @list_type = if @seller.auction
          BuybidCommon::BusinessNames.AUCTION
        elsif @seller.shop
          BuybidCommon::BusinessNames.SHOP
        else @seller.partner
          BuybidCommon::BusinessNames.PARTNER
        else @seller.store
          BuybidCommon::BusinessNames.STORE
        end
      end
    end
  end
end
