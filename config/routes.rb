AndroidSmartUpdates::Application.routes.draw do

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
  devise_for :users
  resources :users
  
  resources :applications do
    resources :versions
  end

  match 'api/update/:application_id/:package_name/:current_version' => 'api#update', 
        :constraints => {:application_id => /\d+/ , :current_version => /\d+/}, as: :check_patchs

  match 'api/download/:application_id/:package_name/:current_version' => 'api#download', 
        :constraints => {:application_id => /\d+/ , :current_version => /\d+/}, as: :down_patchs
        
end