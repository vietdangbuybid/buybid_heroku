Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: 'spree' do
    namespace :admin do
      resources :products do
        member do
          get '/set_visible', to: "products#toggle_visible", as: :toggle_visible
          get '/set_popular', to: "products#toggle_popular", as: :toggle_popular
        end
      end
    end
  end

  scope module: 'buybid' do
    namespace :admin do
      resources :sellers do
        resources :images do
          get '/set_logo', to: "images#set_logo", as: :set_logo
        end
        collection do
          get '(/:list_type)', to: "sellers#index", as: ""
          get '/new/(:list_type)', to: "sellers#new", as: "new"
          post '/(:list_type)', to: "sellers#create", as: :create
        end

        member do
          put '(/:list_type)', to: "sellers#update", as: :update
          get '/edit/(:list_type)', to: "sellers#edit", as: "edit"
          get '/set_visible(/:list_type)', to: "sellers#toggle_popular", as: :toggle_popular
          get '/set_popular(/:list_type)', to: "sellers#toggle_visible", as: :toggle_visible
          get '/edit_rating_and_evals(/:list_type)', to: "sellers#edit_rating_and_evals", as: :edit_rating_and_evals
          get '/contacts(/:list_type)', to: "sellers#contacts", as: :contacts
          get '/contacts/new(/:list_type)', to: "sellers#new_contact", as: :new_contact
          get '/products(/:list_type)', to: "sellers#products", as: :products
          post '/contacts(/:list_type)', to: "sellers#create_contact", as: :create_contact
          patch '/contacts/:contact_id(/:list_type)', to: "sellers#update_contact", as: :update_contact
          delete '/contacts/:contact_id(/:list_type)', to: "sellers#destroy_contact", as: :destroy_contact
        end
      end
    end
  end
  mount Spree::Core::Engine, at: '/'
end
