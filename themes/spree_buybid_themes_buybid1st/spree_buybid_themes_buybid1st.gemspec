# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require_relative '../../buybid_common/lib/buybid_common/variants'
require 'spree_buybid_themes_buybid1st/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_buybid_themes_buybid1st'
  s.version     = SpreeBuybidThemesBuybid1st.version
  s.summary     = "A product of #{BuybidCommon::PRODUCT_COMPANY}"

  s.author    = ['Thuc Nguyen']
  s.email     = ['thuc.nguyen@betterlifejp.com']
  s.homepage  = BuybidCommon::PRODUCT_SITE
  s.license   = BuybidCommon::PRODUCT_LICENSE

  if s.respond_to?(:metadata)
    s.metadata["allowed_push_host"] = BuybidCommon::PRODUCT_GEM_HOST
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # s.files       = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'sass-rails'
  s.add_dependency 'uglifier'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'bootsnap'
  s.add_dependency "rails", BuybidCommon::RAILS_VERSION
  s.add_dependency 'spree_core', BuybidCommon::SPREE_VERSION
  s.add_dependency 'spree_extension'
  s.add_dependency 'mysql2'

  #s.add_development_dependency 'factory_bot', '~> 4.7'
  #s.add_development_dependency 'appraisal'
  #s.add_development_dependency 'awesome_print'
  #s.add_development_dependency 'capybara'
  #s.add_development_dependency 'capybara-screenshot'
  #s.add_development_dependency 'chromedriver-helper'
  #s.add_development_dependency 'coffee-rails'
  #s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot', '~> 4.7'
  #s.add_development_dependency 'ffaker'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  #s.add_development_dependency 'sass-rails'
  #s.add_development_dependency 'selenium-webdriver'
  #s.add_development_dependency 'simplecov'
end
