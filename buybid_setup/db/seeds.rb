# Spree seeds
Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

# Buybid seed
load 'db/buybid/seed_taxonomies_and_taxons.rb'
