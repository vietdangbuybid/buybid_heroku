include Spree::Admin::NavigationHelper

module Admin::Buybid::NavigationHelper
  def per_page_dropdown
    per_page_default = Spree::Config.admin_orders_per_page
    per_page_options = %w{50 100 150}

    selected_option = params[:per_page].try(:to_i) || per_page_default

    select_tag(:per_page,
               options_for_select(per_page_options, selected_option),
               class: "form-control pull-right js-per-page-select per-page-selected-#{selected_option}")
  end
end
