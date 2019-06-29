module Buybid
    module AddressDecorator
			def self.prepended(base)
        base.belongs_to :buybid_sellers
			end
    end
end

Spree::Product.prepend Buybid::AddressDecorator
