Rails.application.routes.draw do
  resources :books
  resources :authors, only: [:index]
  devise_for :authors
  devise_scope :author do
    get '/authors/sign_out' => 'devise/sessions#destroy'
  end
  root 'main#home'
end
