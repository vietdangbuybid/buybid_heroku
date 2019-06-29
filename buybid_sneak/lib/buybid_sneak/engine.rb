module BuybidSneak
  class Engine < ::Rails::Engine
    isolate_namespace BuybidSneak

    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/rpc/**/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
  end
end
