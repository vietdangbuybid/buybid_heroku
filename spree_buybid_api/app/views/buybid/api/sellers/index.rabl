object false
node(:count) { @sellers.count }
node(:total_count) { @sellers.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page].try(:to_i) || Kaminari.config.default_per_page }
node(:pages) { @sellers.total_pages }

child(@sellers => :sellers) do
  extends 'buybid/api/sellers/show'
end
