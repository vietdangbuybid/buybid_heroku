require_relative 'boot'
require 'sneakers'
require 'rails/all'
require "active_storage"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BuybidBatch
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.autoload_paths += Dir["#{config.root}/app/services"]

    # sneakers job: buybid_sneak,..
    config.active_job.queue_adapter = :sneakers
    config.active_job.queue_name_prefix = "buybid_batch_#{Rails.env}"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
