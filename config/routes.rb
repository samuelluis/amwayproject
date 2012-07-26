Amwayproject::Application.routes.draw do

  root :to => 'generator#index'

  match "/generator/get_members/:id" => "generator#get_members"
  match "/admin/generator/:action" => "generator"

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
end
