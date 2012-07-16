Amwayproject::Application.routes.draw do

  root :to => 'generator#index'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
end
