class Subdomain
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www'
  end
end

Rails.application.routes.draw do
  constraints(Subdomain) do
    resources :expenses, controller: 'invoices', :as => 'invoices'
  end

  post '/login',  to: 'home#login'
  post '/signup', to: 'home#signup'
  root 'home#dashboard'
end
