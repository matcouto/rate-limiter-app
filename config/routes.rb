Rails.application.routes.draw do
  root 'home#index'
  get :home, controller: 'home', action: :index
end
