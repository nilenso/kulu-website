class Subdomain
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www'
  end
end

Rails.application.routes.draw do
  constraints(Subdomain) do
    resources :expenses, controller: 'invoices', :as => 'invoices'
  end

  post '/login',   to: 'home#auth'
  get  '/login',   to: 'home#login'
  post '/signin',  to: 'home#signin'
  get  '/signin',  to: 'home#team_signin'

  get  '/logout',  to: 'home#logout'
  post '/signup',  to: 'home#signup'

  root 'home#dashboard'
end
