module Markets
	class ProductCardsFetchRunner
		def run
			Markets::ProductCardsFetch.new(BuybidCommon::Queues::MarketsQueue::MARTKET_PRODUCT_CARDS).execute
		end
	end
end
