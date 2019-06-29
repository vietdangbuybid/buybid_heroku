class Buybid::Product::Create < Buybid::Product::Abstract
	attr_reader :product, :product_attrs, :variants_attrs, :options_attrs

	def initialize(product_attrs, options)
		super()
		@product_attrs = product_attrs.merge(available_on: DateTime.now)
    @product = update_by_code_or_ceate(@product_attrs[:buybid_product_code], @product_attrs)
    @variants_attrs = options[:variants_attrs]
    @options_attrs = options[:options_attrs]
	end

	def execute
    if product.save
      variants_attrs.each do |variant_attribute|
        product.variants.create({ product: product }.merge(variant_attribute))
      end
      setup_options
    end
    product
	end

  private

  def update_by_code_or_ceate(buybid_product_code, product_attributes)
    product = Spree::Product.find_by(buybid_product_code: buybid_product_code)
    if product.present?
      product.update_attributes(product_attributes)
    else
      product = Spree::Product.new(product_attributes)
    end
    product
  end

  def setup_options
    options_attrs.each do |name|
      option_type = Spree::OptionType.where(name: name).first_or_initialize do |option_type|
        option_type.presentation = name
        option_type.save!
      end

      unless product.option_types.include?(option_type)
        product.option_types << option_type
      end
    end
  end		
end
