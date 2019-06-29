object @image

attributes *[:id, :alt]

Spree::TaxonImage.styles.each do |k, _v|
  node("#{k}_url") { |i| main_app.url_for(i.url(k)) }
end
