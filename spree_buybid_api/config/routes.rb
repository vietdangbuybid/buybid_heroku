Spree::Core::Engine.routes.prepend do
  namespace 'api' do 
    namespace 'v1' do
      get 'taxons', to: 'taxons#index', defaults: {format: 'json'}
    end
  end
end