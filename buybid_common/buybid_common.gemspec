$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "buybid_common/version"
require "buybid_common/variants"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = 'buybid_common'
  spec.version     = BuybidCommon::VERSION
  spec.authors     = ['Thuc Nguyen']
  spec.email       = ['thuc.nguyen@betterlifejp.com']
  spec.homepage    = BuybidCommon::PRODUCT_SITE
  spec.summary     = "A product of #{BuybidCommon::PRODUCT_COMPANY}"
  spec.license     = BuybidCommon::PRODUCT_LICENSE

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "#{BuybidCommon::PRODUCT_GEM_HOST}"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "#{BuybidCommon::PRODUCT_LICENSE}", "Rakefile", "README.md"]

  spec.add_dependency 'rails', BuybidCommon::RAILS_VERSION
  spec.add_dependency 'bunny'
end
