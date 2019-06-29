module BuybidBatch
	class TimeSchedule < BuybidBatch::BuybidBatchRecord
		def data_hash
			@data_hash ||= eval(schedule_data).symbolize_keys
		end
	end
end
