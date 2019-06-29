require 'buybid_markets'

Markets::MarketManager.register_agent(Markets::MARKET_NAMES[:yahoo_auction], Markets::Yahoo::YahooAuctionAgent.name)
Markets::MarketManager.register_agent(Markets::MARKET_NAMES[:yahoo_shop], Markets::Yahoo::YahooShopAgent.name)
Markets::MarketManager.register_agent(Markets::MARKET_NAMES[:generic], Markets::Generic::GenericAgent.name)
