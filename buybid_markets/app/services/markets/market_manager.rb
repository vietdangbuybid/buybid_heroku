module Markets
	class MarketManager
		class << self
			def agents_map
				@agents_map ||= Hash.new
			end

			def register_agent(buybid_market_name, clazz)
				agents_map[buybid_market_name] = clazz
			end

			def create_agent_by_market_name(buybid_market_name, settings)
				agents_map[buybid_market_name].constantize.new(buybid_market_name, settings)
			end
		end
	end
end
