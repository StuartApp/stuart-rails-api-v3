Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/v3/health' => 'application#health'
  post '/v3/orders' => 'application#create_order'
end
