Rails.application.routes.draw do
  #resources :logins
  get 'logins' => 'logins#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "/signin", to: "auth#verify_user"
end
