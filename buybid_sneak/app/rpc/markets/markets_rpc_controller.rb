module Markets
  class MarketsRpcController < Gruf::Controllers::Base
    bind ::Rpc::Markets::Service

    def search_product_cards
      products_search = Markets::MarketsSneak.search_product_cards(request.message.buybid_market_name, request.message.page_index, 
          request.message.page_size, eval(request.message.filters).deep_symbolize_keys)
      Rpc::SearchProductCardsResp.new(
        buybid_market_name: request.message.buybid_market_name,
        filters: eval(request.message.filters).symbolize_keys.to_s,
        page_size: request.message.page_size,
        page_index: request.message.page_index,
        page_next: request.message.page_index + 1,
        sellers: products_search[:sellers],
        products: products_search[:products]
      )
    rescue => e
      fail!(:not_found, :buybid_market_name, "Failed to agent: #{request.message.buybid_market_name}, exception: #{e}")
    end

    def get_product_detail
      product_detail = Markets::MarketsSneak.get_product_detail(request.message.buybid_market_name, request.message.product_id)
      Rpc::GetProductDetailResp.new(
        buybid_market_name: request.message.buybid_market_name,
        product_id: request.message.product_id,
        #seller: product_detail[:seller],
        product: product_detail[:product]
      )
    rescue => e
      fail!(:not_found, :buybid_market_name, "Failed to agent: #{request.message.buybid_market_name}, exception: #{e}")
    end

    def parse_link
      buybid_market_name = request.message.buybid_market_name || Markets::MARKET_NAMES[:generic]
      link_data = Markets::MarketsSneak.parse_link(buybid_market_name, request.message.link_url)
      res = Rpc::ParseLinkResp.new(
        buybid_market_name: buybid_market_name,
        link_url: request.message.link_url,
        link_home_url: request.message.link_url
      )
      link_data.each do |key, value|
        res.data[key] = value if value.present?
      end
      res
    rescue => e
      fail!(:not_found, :buybid_market_name, "Failed to agent: #{request.message.buybid_market_name}, exception: #{e}")
    end
  end
end
