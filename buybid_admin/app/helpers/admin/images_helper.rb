module Admin::ImagesHelper
  # The button style for the in-use button
  def image_button_style(seller, image)
    (image.present? && seller.spree_image.present? && seller.spree_image.id == image.id) ? "btn btn-primary btn-sm" : "btn btn-danger btn-sm"
  end

  # The button icon for the in-use button
  def image_button_icon(seller, image)
    (image.present? && seller.spree_image.present? && seller.spree_image.id == image.id) ? "glyphicon glyphicon-ok" : "glyphicon glyphicon-remove"
  end
end