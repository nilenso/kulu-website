Rails.application.routes.draw do
  resources :expenses, controller: 'invoices', :as => 'invoices'

  get '/login',  to: 'home#login'
  get '/logout',  to: 'home#logout'

  get '/callback', to: 'home#callback'

  root 'home#dashboard'
end
