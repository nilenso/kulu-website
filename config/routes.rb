Rails.application.routes.draw do
  constraints(Subdomain) do
    resources :expenses, controller: 'invoices', :as => 'invoices'
  end

  resources :extractor, controller: 'extractor', :as => 'extractor' do
    collection do
      get  :login
      post :authorize
    end
  end

  post '/login',   to: 'home#auth'
  get  '/login',   to: 'home#login'
  post '/signin',  to: 'home#signin'
  get  '/signin',  to: 'home#team_signin', as: :team_signin

  get  '/forgot_password',  to: 'home#forgot_password'
  post '/forgot',  to: 'home#forgot'

  get  '/verify_password',  to: 'home#verify_password'
  post '/update_password',  to: 'home#update_password'

  get  '/logout',  to: 'home#logout'
  post '/signup',  to: 'home#signup'

  root 'home#dashboard'
end
