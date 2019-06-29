# frozen_string_literal: true

module Buybid
  module Admin
    class SellersController < Spree::Admin::BaseController
      before_action :set_seller, only: %i[show edit update destroy toggle_visible toggle_popular edit_details edit_rating_and_evals contacts update_contact new_contact create_contact products]
      before_action :set_contact, only: %i[update_contact destroy_contact]
      before_action :filter_sellers, :load_main_category_id, only: [:index]
      before_action :set_list_type
      before_action :set_default_values_for_edit, only: [:edit]
      before_action :set_default_values_for_new, only: [:new]

      def index; end

      def show; end

      def products
        @products = @seller.spree_products.all
      end

      def create
        @seller = Buybid::Seller.new(seller_params.except(:attachment, :category_taxon_ids))
        respond_with(@seller) do |format|
          # Validate attachment type before saving
          if @seller.set_logo(seller_params[:attachment]) && @seller.save
            @seller.set_visible_and_popular(seller_params[:visible], seller_params[:popular])
            @seller.set_type(seller_params[:auction], seller_params[:shop], seller_params[:partner], seller_params[:store])
            @seller.update_category(seller_params[:category_taxon_ids])
            @seller.set_main_category_id(seller_params[:main_category_id]) if seller_params[:main_category_id].present?

            format.html { redirect_to admin_sellers_path(@list_type), notice: 'Seller is successfully created!' }
            format.json { render :index, status: :created, location: @seller }
          else
            flash[:error] = @seller.errors.full_messages
            format.html { render :new, locals: { category_taxon_ids: seller_params[:category_taxon_ids] } }
            format.json { render json: @seller.errors.full_messages, status: :unprocessable_entity }
          end
        end
      end

      def new
        @seller = Buybid::Seller.new
      end

      def edit
        @seller = Buybid::Seller.find_by_id(params[:id])
      end

      def update
        @seller.update_attributes(seller_params.except(:category_taxon_ids, :attachment))
        respond_to do |format|
          if  @seller.set_logo(seller_params[:attachment]) && @seller.save
            @seller.set_visible_and_popular(seller_params[:visible], seller_params[:popular])
            @seller.update_category(seller_params[:category_taxon_ids])
            @seller.set_main_category_id(seller_params[:main_category_taxon_id]) if seller_params[:main_category_taxon_id].present?
            format.html { redirect_to admin_sellers_path(@list_type), notice: "Seller #{@seller.name} is successfully udapted" }
            format.json { render :show, status: :updated, location: @seller }
          else
            flash[:error] = @seller.errors.full_messages
            format.html { render 'edit' }
            format.json { render :edit, status: :edit, location: @seller }
          end
        end
      end

      # Soft delete the seller, the seller records still in the db. However, the delete button still intact
      def destroy
        respond_to do |format|
          if @seller.mark_as_deleted
            format.html { redirect_to admin_sellers_path(@list_type), notice: "Seller #{@seller.name} is deleted successfully!" }
            format.json { render :index, status: :success }
          else
            format.html { redirect_to '/admin/sellers/partners', notice: "Seller #{@seller.name} cannot be deleted!. #{@seller.errors.full_messages}" }
            format.json { render :index, status: :unprocessable_entity }
          end
        end
      end

      # If set to false, seller will no longer be visible on the client
      def toggle_visible
        @seller.toggle(:visible)

        respond_to do |format|
          if @seller.save
            format.html { redirect_to admin_sellers_path(@list_type), notice: "Seller #{@seller.name}'s visibility is now set to #{@seller.visible?}" }
          else
            flash[:error] = "Seller #{@seller.name} failed to set visible to #{!@seller.visible}. Error: #{@seller.errors.full_messages}"
            format.html { redirect_to admin_sellers_path(@list_type) }
          end
        end
      end

      # If set to false, seller will no longer be popular on the client
      def toggle_popular
        @seller.toggle(:popular)

        respond_to do |format|
          if @seller.save
            format.html { redirect_to admin_sellers_path(@list_type), notice: "Seller #{@seller.name}'s popularity is now set to #{@seller.popular?}" }
          else
            flash[:error] = "Seller #{@seller.name} failed to set visible to #{!@seller.popular}. Error: #{@seller.errors.full_messages}"
            format.html { redirect_to admin_sellers_path(@list_type) }
          end
        end
      end

      def edit_rating_and_evals; end

      # show all the contacts of a specific seller
      def contacts
        @contacts = @seller.get_contacts
      end

      # Create a new contact for each seller
      def new_contact
        @contact = Spree::Address.new
      end

      # Create a new contact and save it to the database
      def create_contact
        @contact = Spree::Address.new(contact_params)
        # Currently for demo, I will leave the country id to be 1, later update will be noticed!
        hard_code_contact(contact_params)
        respond_to do |format|
          if @contact.save
            @seller.spree_addresses << @contact
            format.html { redirect_to contacts_admin_seller_path, notice: "Contacts #{@contact.firstname} #{@contact.lastname} is successfully created!" }
          else
            flash[:error] = @contact.errors.full_messages
            format.html { render :new_contact }
            format.json { render :new_contact, status: :unprocessable_entity }
          end
        end
      end

      # Update the contact of each individual seller
      def update_contact
        # hard_code_contact(contact_params)
        respond_to do |format|
          if @contact.update_attributes(contact_params)
            format.html { redirect_to contacts_admin_seller_path(@seller), notice: 'Contact has successfully been updated!' }
          else
            flash[:error] = @contact.errors.full_messages
            format.html { redirect_to contacts_admin_seller_path(@seller), notice: 'Contact failed to be saved!' }
            format.json { render :contacts, status: :unprocessable_entity }
          end
        end
      end

      # Update the new contact record into the database
      def destroy_contact
        respond_to do |format|
          if @contact.destroy
            format.html { redirect_to contacts_admin_seller_path, notice: "Contacts #{@contact.firstname} #{@contact.lastname} is successfully destroy!" }
          else
            format.html { redirect_to contacts_admin_seller_path, notice: "Contacts #{@contact.firstname} #{@contact.lastname} cannot be updated #{@contact.errors.full_messages}" }
          end
        end
      end

      private

      # Using the collection to query sellers based on the search results
      def filter_sellers
        params[:q] ||= {}
        params[:q][:visible] ||= '0'
        params[:q][:popular] ||= '0'
        params[:q][:main_category_id] ||= nil
        params[:q][:account_code] ||= nil

        @seller = if params[:list_type].chomp('s') == BuybidCommon::BusinessNames::AUCTION
          Buybid::Seller.auction
        elsif params[:list_type].chomp('s') == BuybidCommon::BusinessNames::SHOP
          Buybid::Seller.shop
        elsif params[:list_type].chomp('s') == BuybidCommon::BusinessNames::PARTNER
          Buybid::Seller.partner
        elsif params[:list_type].chomp('s') == BuybidCommon::BusinessNames::STORE
          Buybid::Seller.store
        else
          Buybid::Seller.all
        end

        # set default sort in created at with desc
        params[:q][:s] ||= 'created_at desc'
        
        #================================
        @q = @seller.ransack(params[:q])
        @sellers = @q.result.all
        #================================
        
        if params[:q][:account_code].present?
          @sellers = @sellers.where(account_code: params[:q][:account_code])
        end

        # filter with visible
        if params[:q][:visible] == '1'
          @sellers = @sellers.visible
        elsif params[:q][:visible] == '2'
          @sellers = @sellers.not_visible
        end

        # filter with popular
        if params[:q][:popular] == '1'
          @sellers = @sellers.popular
        elsif params[:q][:popular] == '2'
          @sellers = @sellers.not_popular
        end

        # filter with main category id
        if params[:q][:main_category_id].present?
          @sellers = @sellers.where(main_category_id: params[:q][:main_category_id])
        end

        @sellers = @sellers.page(params[:page]).per(params[:per_page])
        @sellers_count = @sellers.where(is_deleted: 0).to_a.count
      end

      def set_seller
        @seller = Buybid::Seller.find(params[:id])
      end

      def set_contact
        @contact = Spree::Address.find(params[:contact_id])
      end

      def set_list_type
        if params[:list_type].present?
          @list_type = if params[:list_type][-1] != 's'
            params[:list_type] << 's'
          else
            params[:list_type]
          end
        elsif @seller.present?
          if @seller.auction?
            @list_type = BuybidCommon::BusinessNames::AUCTION
          elsif @seller.shop?
            @list_type = BuybidCommon::BusinessNames::SHOP
          elsif @seller.partner?
            @list_type = BuybidCommon::BusinessNames::PARTNER
          else
            @list_type = BuybidCommon::BusinessNames::ALL
          end
        else
          @list_type = BuybidCommon::BusinessNames::ALL
        end
        @list_type
      end

      def seller_params
        params.fetch(:buybid_seller, {}).permit(:list_type, :name, :description, :phone_number, :positon,
                                                :account_code, :category_taxon_ids, :auction, :shop, :partner, :store, :order_count, :URL, :comprehensive_evaluation,
                                                :last_evaluation, :position, :attachment, :visible, :popular, :rating_point, :rating_total_good,
                                                :rating_total_bad, :rating_is_suspended, :rating_url, :rating_is_deleted, :address, :main_category_id, :meta_keywords, :meta_title, :meta_description)
      end

      def contact_params
        params.require(:address).permit(:firstname, :lastname, :zipcode, :phone, :address1, :address2,
                                        :city, :country_id, :state, :phone, :alternative_phone)
      end

      # Currently, spree address model requires many fields to be present
      # Therefore, create dumb data to populate those address fields
      def hard_code_contact(contact_params)
        country = Spree::Country.find_by(iso: 'JP')
        if Spree::Country.find_by(iso: 'JP').nil?
          hard_code_to_create_country('Japan', 'JP', 'JPN', 'Japan', 1, false, false)
        else
          # The zipcode and states should not be required
          country.update_attribute(:zipcode_required, false)
          country.update_attribute(:states_required, false)
        end

        # Default the country to be Japan
        @contact.country_id = country.id
        @contact.state_id = 1

        # Update attriubte for the firstname
        @contact.firstname = @seller.name if contact_params[:firstname].blank?

        # if last name is built
        @contact.lastname = @seller.name if contact_params[:lastname].blank?

        # If zipcode is required
        @contact.zipcode = '70000' if contact_params[:zipcode].blank?

        # If city is blank, then default set it to japan
        @contact.city = 'Please fill in contact' if contact_params[:city].blank?

        # If phone is blank, then set it to 123456
        @contact.phone = '123456' if contact_params[:phone].blank?
      end

      # This will be deleted at later date. Created because country default at Japan when creating a new contact
      def hard_code_to_create_country(iso_name, iso, iso3, name, numcode, states_required, zipcode_required)
        @country = Spree::Country.create(iso_name: iso_name, iso: iso, iso3: iso3, name: name, numcode: numcode, states_required: states_required, zipcode_required: zipcode_required)
        if @country.save
          puts 'Successful!'
        else
          puts @country.errors.full_messages
        end
      end

      def set_default_values_for_edit
        @position = @seller.position
        @order_count = @seller.order_count
      end

      def set_default_values_for_new
        @position = '1'
        @order_count = '0'
      end
    end
  end
end
