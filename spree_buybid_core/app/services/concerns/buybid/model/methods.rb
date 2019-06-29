module Concerns::Buybid::Model::Methods
	extend ActiveSupport::Concern

	def create!(product_attrs)
		self.model_clazz.create!(product_attrs.stringify_keys.slice(*column_names).except(:create_at, :updated_at, :id))
	end

	def save!(product_attrs)
		self.model_clazz.save!(product_attrs.stringify_keys.slice(*column_names).except(:create_at, :updated_at))
	end

	def update!(product_attrs)
		save!(product_attrs)
	end

	private

	def column_names
		self.model_clazz.column_names
	end
end
