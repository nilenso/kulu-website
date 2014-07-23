Rails.application.routes.draw do
  resources :invoices

  root 'home#dashboard'
end
