Rails.application.routes.draw do
   devise_for :admin_users, ActiveAdmin::Devise.config
   ActiveAdmin.routes(self)

   scope "api" do
      post "/sign_up", to: "logins#sign_up"
      post "/sign_in", to: "auth#login"
   end
end
