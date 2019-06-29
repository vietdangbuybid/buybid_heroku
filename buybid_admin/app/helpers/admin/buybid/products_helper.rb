module Admin::Buybid::ProductsHelper
    
  # Define the style of the button
  def button_style_product(setting, product = nil)
    if (setting == :buybid_visible)
      return product.buybid_visible? ? "btn btn-primary btn-sm" : "btn btn-danger btn-sm"
    elsif (setting == :buybid_popular)
      return product.buybid_popular? ? "btn btn-primary btn-sm" : "btn btn-danger btn-sm"
    else (setting == :deleted)
      return "btn btn-danger btn-sm"
    end
  end

  # Define the icon of the button (Using twitter-bootstrap-rails gem)
  def button_icon_product(setting, product = nil)
    if (setting == :buybid_visible)
      return product.buybid_visible? ? "glyphicon glyphicon-ok" : "glyphicon glyphicon-remove"
    elsif (setting == :buybid_popular )
      return product.buybid_popular? ? "glyphicon glyphicon-ok"  : "glyphicon glyphicon-remove"
    elsif (setting == :deleted)
      return "glyphicon glyphicon-remove"
    end
  end

end
