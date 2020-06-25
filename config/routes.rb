Rails.application.routes.draw do
   devise_for :admin_users, ActiveAdmin::Devise.config
   ActiveAdmin.routes(self)

   scope "api" do
      post "/sign_up", to: "logins#sign_up"
      post "/sign_in", to: "auth#login"
      get "/profile_info/:id", to: "profiles#get_info"
      post "/profile_info/:id", to: "profiles#update_info"
      get "/car_brands", to: "car_brands#index"
      get "/car_brands/:id/models", to: "car_brands#get_car_models"
   end
end
