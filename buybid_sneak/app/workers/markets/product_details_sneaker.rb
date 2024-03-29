require 'sneakers'
require 'json'

module Markets
	class ProductDetailsSneaker
		include Sneakers::Worker
		from_queue BuybidSneak::SneakJob::SNEAK_JOB_QUEUE_NAMES[:martket_product_details_sneak]

		def work(msg)
	    begin
	      job_data = ActiveSupport::JSON.decode(msg)
	      ActiveJob::Base.execute job_data
	      ack!
	    rescue
	      reject!
	    end			
		 end
	end
end
