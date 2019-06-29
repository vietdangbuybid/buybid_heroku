module Markets
	class SneakProductCardsJob < BuybidSneak::SneakJob
		queue_as BuybidSneak::SneakJob::SNEAK_JOB_QUEUE_NAMES[:martket_product_cards_sneak]
		
	  def perform(buybid_market_name, category_id)
	  	Rails.logger.info "Markets::SneakProductCardsJob.perform('#{buybid_market_name}', #{category_id})"
	    #search_page = Markets::MarketSneak.search_product_cards(buybid_market_name, 100, 1, { category_id: category_id, query: nil })
	    #loop do
	    #	break if search_page.products.blank?
	    #	search_page = Markets::MarketsSneak.search_product_cards(buybid_market_name, 100, search_page[:page_index_next], { category_id: category_id, query: nil })
	    #end
	    Rails.logger.info "Markets::SneakProductCardsJob.perform end"
	  end
	end
end
