Rails.application.routes.draw do
  root :to => 'sessions#new'

  ActiveAdmin.routes(self)

  resources :events

  scope controller: :sessions do
    get   'login' => :new
    match 'logout' => :destroy, :via => [:get, :destroy]
    match 'sessions/create' => :create, :via => [:get, :post]
  end
end
