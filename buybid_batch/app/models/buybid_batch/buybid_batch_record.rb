module BuybidBatch
	class BuybidBatchRecord < Spree::Base
	  self.abstract_class = true
	  self.table_name_prefix = 'buybid_batch_'
	end
end
