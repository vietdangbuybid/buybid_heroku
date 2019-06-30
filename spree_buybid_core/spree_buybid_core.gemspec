lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require_relative '../buybid_common/lib/buybid_common/variants'
require 'spree_buybid_core/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_buybid_core'
  s.version     = SpreeBuybidCore.version
  s.summary     = "A product of #{BuybidCommon::PRODUCT_COMPANY}"

  s.author    = ['Viet Dang']
  s.email     = ['vietdangbuybid@gmail.com']
  s.homepage  = BuybidCommon::PRODUCT_SITE
  s.license   = BuybidCommon::PRODUCT_LICENSE

  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = BuybidCommon::PRODUCT_GEM_HOST
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # s.files       = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'active_record_union'
  s.add_dependency 'rails', BuybidCommon::RAILS_VERSION
  s.add_dependency 'spree_core', BuybidCommon::SPREE_VERSION
  # s.add_dependency 'spree_backend', BuybidCommon::SPREE_VERSION
  s.add_dependency 'elasticsearch'
  s.add_dependency 'elasticsearch-model'
  s.add_dependency 'elasticsearch-persistence'
  s.add_dependency 'elasticsearch-rails'
  s.add_dependency 'mysql2'
  s.add_dependency 'spree_extension', BuybidCommon::SPREE_EXTENSION
  s.add_dependency 'unicorn'
  # Those gems are used for deploying this app to heroku
  #s.add_dependency 'sqlite3'
  s.add_dependency 'pg'
  s.add_dependency 'figaro'
  s.add_dependency 'rails_12factor'
  s.add_dependency 'capistrano'
  s.add_dependency 'capistrano3-puma'
  s.add_dependency 'capistrano-rails'
  s.add_dependency 'capistrano-bundler'
  s.add_dependency 'capistrano-rvm' 

  #s.add_development_dependency 'factory_bot', '~> 4.7'
  #s.add_development_dependency 'appraisal'
  #s.add_development_dependency 'awesome_print'
  #s.add_development_dependency 'capybara'
  #s.add_development_dependency 'capybara-screenshot'
  #s.add_development_dependency 'chromedriver-helper'
  #s.add_development_dependency 'coffee-rails'
  #s.add_development_dependency 'database_cleaner'
  #s.add_development_dependency 'factory_bot', '~> 4.7'
  #s.add_development_dependency 'ffaker'
  #s.add_development_dependency 'pry'
  #s.add_development_dependency 'rspec-rails'
  #s.add_development_dependency 'sass-rails'
  #s.add_development_dependency 'selenium-webdriver'
  #s.add_development_dependency 'simplecov'

end
