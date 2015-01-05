Rails.application.routes.draw do
  resources :expenses, controller: 'invoices', :as => 'invoices'

  root 'home#dashboard'
end
