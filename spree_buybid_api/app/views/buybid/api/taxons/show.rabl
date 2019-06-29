object @taxon
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes *[:id, :name, :permalink, :pretty_name, :depth]

child icon: :image do
  extends 'buybid/api/taxon_images/show'
end
