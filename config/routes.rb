Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/v3/health' => 'application#health'
  post '/v3/orders' => 'application#create_order'
  post '/v3/orders/http-delay' => 'application#create_order_http_delay'
  post '/v3/orders/http-random-delay' => 'application#create_order_http_random_delay'
end
