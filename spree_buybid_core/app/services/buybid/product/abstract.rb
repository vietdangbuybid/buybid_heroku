class Buybid::Product::Abstract < Buybid::ModelService		
	def initialize
		super(Spree::Product)
	end
	def execute; end
end
