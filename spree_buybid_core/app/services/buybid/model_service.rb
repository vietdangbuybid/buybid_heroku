class Buybid::ModelService
	attr_accessor :model_clazz

	include Concerns::Buybid::Model::Methods
	
	def initialize(model_clazz)
		self.model_clazz = model_clazz
	end
end

