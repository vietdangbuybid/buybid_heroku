module Markets
	class ProductDetailFetchRunner
		def run
			Markets::ProductDetailFetch.new(BuybidCommon::Queues::MarketsQueue::MARTKET_PRODUCT_DETAIL).execute
		end
	end
end
