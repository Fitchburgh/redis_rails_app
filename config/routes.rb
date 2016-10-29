Rails.application.routes.draw do
  get '/artists/guess'

  post '/artists/return'
  resources :artists
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
