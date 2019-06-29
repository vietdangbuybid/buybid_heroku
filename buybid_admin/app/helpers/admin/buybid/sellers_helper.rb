module Admin::Buybid::SellersHelper
  def display_seller_contact_title(contact, index)
    "Contact " + index.to_s + ": " + contact.firstname + " " + contact.lastname
  end

  def available_provinces
    provinces = Spree::Country.find_by(iso: "JP").states
  end

  def style_deleted(seller)
    "color:red" if seller.is_deleted?
  end

  def all?(list_type)
    false if list_type.nil?
    list_type.chomp('s') == BuybidCommon::BusinessNames::ALL
  end

  def auction?(list_type)
    false if list_type.nil?
    list_type.chomp('s') == BuybidCommon::BusinessNames::AUCTION
  end

  def shop?(list_type)
    false if list_type.nil?
    list_type.chomp('s') == BuybidCommon::BusinessNames::SHOP
  end

  def partner?(list_type)
    false if list_type.nil?
    list_type.chomp('s') == BuybidCommon::BusinessNames::PARTNER
  end

  def store?(list_type)
    false if list_type.nil?
    list_type.chomp('s') == BuybidCommon::BusinessNames::STORE
  end

  def show_category_name(seller)
    Spree::Taxon.find(seller.main_category_id).name if Spree::Taxon.exists?(seller.main_category_id)
  end

  # Show the seller logo
  def show_logo(seller, size: nil)
    logo = seller.spree_image
    link_to image_tag( main_app.url_for(logo.url(:size))), main_app.url_for(logo.url(:size)) if logo.present?
  end
  # Define the style of the button
  def button_style(setting, seller = nil)
    if (setting == :visible)
      return seller.visible? ? "btn btn-primary btn-sm" : "btn btn-danger btn-sm"
    elsif (setting == :popular)
      return seller.popular? ? "btn btn-primary btn-sm" : "btn btn-danger btn-sm"
    else (setting == :deleted)
      return "btn btn-danger btn-sm"
    end
  end

  # Define the icon of the button (Using twitter-bootstrap-rails gem)
  def button_icon(setting, seller = nil)
    if (setting == :visible)
      return seller.visible? ? "glyphicon glyphicon-ok" : "glyphicon glyphicon-remove"
    elsif (setting == :popular )
      return seller.popular? ? "glyphicon glyphicon-ok"  : "glyphicon glyphicon-remove"
    elsif (setting == :deleted)
      return "glyphicon glyphicon-remove"
    end
  end

  def image_button_style(seller, image)
    logo = seller.spree_image
    logo.id == image.id ? "btn btn-primary btn-sm" : "btn btn-danger btn-sm"
  end

  def image_button_icon(seller,image)
    logo = seller.spree_image
    logo.id == image.id ? "glyphicon glyphicon-ok" : "glyphicon glyphicon-remove "
  end

  def seller_category_taxon_ids(seller)
    seller.category_taxon_ids if seller.category_taxon_ids.present?
  end

  # Used to repopulate the field at new when validation fails
  def seller_params(params, attribute: nil)
    params[:attribute] if params.present? && params[:attribute].present?
  end

  def seller_check(seller, attr)
    return true if seller.attr?
  end

  #Show create time using the current time zone, will use the current time zone as default
  def show_created_time(created_at, format)
    created_at.in_time_zone('Asia/Bangkok').strftime(format)
  end
end
