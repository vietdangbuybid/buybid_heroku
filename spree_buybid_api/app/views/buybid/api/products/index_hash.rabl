object false

node(:count) { @products.count }
node(:total_count) { @products.total.try(:value) || @products.total }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page].try(:to_i) || Kaminari.config.default_per_page }
node(:pages) { (@products.total.try(:value) + params[:per_page].try(:to_i) -1)/params[:per_page].try(:to_i) unless params[:per_page].nil?}

child(@products.map(&:_source) => :products) do
  extends 'buybid/api/products/show_hash'
end
