require_relative '../buybid_common/lib/buybid_common/variants'

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', BuybidCommon::RAILS_VERSION
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'aws-sdk-s3'
gem 'mysql2'

# integrations
gem 'redis'
gem 'hiredis'

# buybid framework
gem 'buybid_common', path: '../buybid_common'
gem 'buybid_fetch', path: '../buybid_fetch'
gem 'spree_buybid_core', path: '../spree_buybid_core'
gem 'spree_buybid_api', path: '../spree_buybid_api'
gem 'spree_buybid_themes_buybid1st', path: '../themes/spree_buybid_themes_buybid1st'

# spree framework
gem 'spree_core', BuybidCommon::SPREE_VERSION
gem 'spree_api', BuybidCommon::SPREE_VERSION
gem 'spree_frontend', BuybidCommon::SPREE_VERSION
gem 'spree_auth_devise', BuybidCommon::SPREE_AUTH_DEVISE_VERSION
gem 'spree_gateway', BuybidCommon::SPREE_GATEWAY_VERSION

# spree spree-contrib
gem 'spree_multi_currency', github: 'spree-contrib/spree_multi_currency'
gem 'spree_static_content', github: 'spree-contrib/spree_static_content'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'dotenv-rails'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]