module Markets
	class MarketRpc
		class << self
			def search_product_cards(buybid_market_name, page_index, page_size, filters)
				begin
				  response = markets_rpc.call(:search_product_cards, buybid_market_name: buybid_market_name, page_index: page_index, page_size: page_size, filters: filters.stringify_keys.to_s)
				  response.message
				rescue Gruf::Client::Error => e
				  e.error.inspect
				end
			end

			def get_product_detail(buybid_market_name, product_id)
				begin
				  response = markets_rpc.call(:get_product_detail, buybid_market_name: buybid_market_name, product_id: product_id)
				  response.message
				rescue Gruf::Client::Error => e
				  e.error.inspect
				end
			end

			def parse_link(buybid_market_name, link_url)
				begin
				  response = markets_rpc.call(:parse_link, buybid_market_name: buybid_market_name, link_url: link_url)
				  response.message
				rescue Gruf::Client::Error => e
				  e.error.inspect
				end
			end

			private
			
			def markets_rpc
				@@markets_rpc ||= ::Gruf::Client.new(service: Rpc::Markets, options: { hostname: hostname })
			end

			def hostname
				"#{Rails.application.credentials.dig(:rpc, :host)}:#{Rails.application.credentials.dig(:rpc, :port)}"
			end
		end
	end
end
