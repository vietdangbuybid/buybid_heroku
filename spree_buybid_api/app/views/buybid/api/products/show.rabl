object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes *[:id, :name, :description, :price, :display_price, :available_on, :slug, :total_on_hand, :buybid_auction, :buybid_shop, :buybid_partner, :buybid_store, :buybid_hot, :buybid_new]

node(:display_price) { |p| p.display_price.to_s }
node(:in_stock, &:in_stock?)
node(:total_on_hand, &:total_on_hand)

child buybid_seller: :seller do
  extends 'buybid/api/sellers/show'
end

child image: :image do 
  extends 'buybid/api/images/show'
end
