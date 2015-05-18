Rails.application.routes.draw do
  constraints(Subdomain) do
    resources :expenses, controller: 'invoices', :as => 'invoices'
  end

  resources :transcriber, controller: 'transcriber', :as => 'transcriber' do
    collection do
      get  :login
      post :authorize
    end
  end

  post '/login',   to: 'home#auth'
  get  '/login',   to: 'home#login'
  post '/signin',  to: 'home#signin'
  get  '/signin',  to: 'home#team_signin', as: :team_signin

  get  '/forgot_password',  to: 'home#forgot_password', as: :forgot_password
  post '/forgot',  to: 'home#forgot'

  get  '/verify_password/:token',  to: 'home#verify_password'
  post '/update_password',  to: 'home#update_password'

  get  '/logout',  to: 'home#logout'
  post '/signup',  to: 'home#signup'

  get  '/admin', to: 'admin#index'
  post '/invite', to: 'admin#invite'
  post '/member_signup', to: 'home#member_signup'
  get  '/verify_invite/:token', to: 'home#verify_invite'

  root 'home#dashboard'
end
