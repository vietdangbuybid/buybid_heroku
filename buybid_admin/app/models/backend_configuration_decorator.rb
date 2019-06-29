module Buybid
  module BackendConfigurationDecorator
    SELLER_TABS ||= [:sellers, :auction, :shop, :partner]
  end
end

Spree::BackendConfiguration.prepend Buybid::BackendConfigurationDecorator
