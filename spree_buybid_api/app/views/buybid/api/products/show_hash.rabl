object @product 
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes *[
  :id, 
  :name, 
  :description, 
  :buybid_product_code, 
  :current_price,
  :available_on, 
  :slug, 
  :total_on_hand, 
  :current_price,
  :buynow_price,
  :buybid_auction, 
  :buybid_shop, 
  :buybid_partner, 
  :buybid_store, 
  :buybid_hot, 
  :buybid_new, 
  :brand_names,
  :category_names,
  :discontinue_on,
  :created_at
]

node(:price) {|product| product[:formatted_price]}
node(:display_price) {|product| product[:displayed_price]}
node(:image) {|product| product[:image]}
node(:shipping_category) {|product| product[:shipping_category]}

#child image: :image do 
  #extends 'buybid/api/images/show'
#end

# Hard Code total bids of products
node(:bids) {|product| product[:id]}
node(:taxons) {|product| product[:taxons]}
node(:seller) {|product| product[:buybid_seller]}

