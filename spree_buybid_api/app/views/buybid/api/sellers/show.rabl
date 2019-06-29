object @seller
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes *[:id, :name, :seller_code, :description, :rating_point, :order_count, :URL, :auction?, :shop?, :partner?, :store?, :popular?, :visible?, :position]

child :main_category => :category do 
  extends 'buybid/api/taxons/show'
end

child :spree_image => :image do
  extends 'buybid/api/images/show'
end
