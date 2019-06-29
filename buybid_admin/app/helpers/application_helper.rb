module ApplicationHelper
  def edit_admin_product_seller_path(product)
    return "/admin/sellers/#{product.buybid_seller.id}/edit" if product.buybid_seller.present?
    "/admin/sellers"
  end
end
