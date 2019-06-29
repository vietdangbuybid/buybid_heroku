module Markets
	class SneakProductDetailsJob < BuybidSneak::SneakJob
		queue_as BuybidSneak::SneakJob::SNEAK_JOB_QUEUE_NAMES[:martket_product_detail_sneak]
		
	  def perform(buybid_market_name, product_ids)
	  	Rails.logger.info "Markets::SneakProductDetailsJob.perform('#{buybid_market_name}', #{product_ids})"
	  	#Markets::MarketsSneak.get_product_detail(args[:buybid_market_name], args[:product_ids])
	  	Rails.logger.info "Markets::SneakProductDetailsJob.perform end"
	  end
	end
end
