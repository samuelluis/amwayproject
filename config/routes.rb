Amwayproject::Application.routes.draw do
  resources :members

  resources :people

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
end
