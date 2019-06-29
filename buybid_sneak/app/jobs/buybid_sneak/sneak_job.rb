module BuybidSneak
	class SneakJob < ActiveJob::Base
		SNEAK_JOB_QUEUE_NAMES = {
		  martket_product_cards_sneak: :martket_product_cards_sneak,
		  martket_product_details_sneak: :martket_product_details_sneak
		}.freeze

	end
end
