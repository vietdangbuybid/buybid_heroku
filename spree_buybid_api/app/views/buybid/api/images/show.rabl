object @image

attributes *[:id, :alt]

node("product_url") { |image| main_app.url_for(image[:product_url]) }

#Spree::Image.styles.each do |k, _v|
  #node("#{k}_url") { |i| main_app.url_for(i.url(k)) }
#end

