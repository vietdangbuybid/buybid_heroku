module BuybidCommon
  class Engine < ::Rails::Engine
    isolate_namespace BuybidCommon

    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
  end
end
