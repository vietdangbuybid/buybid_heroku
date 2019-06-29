default_shipping_category = Spree::ShippingCategory.find_by!(name: 'Default')
clothing = Spree::TaxCategory.find_by!(name: 'Clothing')
small = Spree::OptionValue.where(name: 'Small').first
medium = Spree::OptionValue.where(name: 'Medium').first
large = Spree::OptionValue.where(name: 'Large').first
extra_large = Spree::OptionValue.where(name: 'Extra Large').first

red = Spree::OptionValue.where(name: 'Red').first
blue = Spree::OptionValue.where(name: 'Blue').first
green = Spree::OptionValue.where(name: 'Green').first

#Markets::MarketCrawler.search_products('yahoo_shop', 10, 1, '')

product_attrs = {name: "Name #{srand}", description: "Description #{srand}", available_on: DateTime.now, tax_category_id: clothing.id, price: 15.99, shipping_category_id: default_shipping_category.id}

product = Buybid::Product::Create.new(product_attrs).execute

properties = {
  'Manufacturer' => 'Jerseys',
  'Brand' => 'Conditioned',
  'Model' => 'TL9002',
  'Shirt Type' => 'Ringer T',
  'Sleeve Type' => 'Short',
  'Made from' => '100% Vellum',
  'Fit' => 'Loose',
  'Gender' => 'Men\'s'
}

properties.each do |prop_name, prop_value|
  product.set_property(prop_name, prop_value)
end

sku = "BUYBID-#{product.id}"

#Spree::Variant.create!({product: product, option_values: [small, red], sku: sku, cost_price: product_attrs[:price]})# if Spree::Variant.where(product_id: product.id, sku: sku).none?

product.master.update!({
  sku: sku,
  cost_price: product_attrs[:price],
  option_values: [small, red]
})

country =  Spree::Country.find_by(iso: 'JP')
location = Spree::StockLocation.first_or_create!(name: 'default',
                                                 address1: '123 Tokyo Str',
                                                 city: 'Tokyo',
                                                 zipcode: '12345',
                                                 country: country,
                                                 state: country.states.first)
location.active = true
location.save!

Spree::Variant.where(product_id: product.id).each do |variant|
  variant.stock_items.each do |stock_item|
    Spree::StockMovement.create(quantity: 10, stock_item: stock_item)
  end
end
