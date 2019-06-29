module BuybidBatch
	class MarketSetting < BuybidBatch::BuybidBatchRecord
		def values_hash
			@values_hash ||= eval(setting_values).deep_symbolize_keys
		end
	end
end
