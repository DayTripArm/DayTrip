Rails.application.routes.draw do
   #devise_for :logins, :controllers => {omniauth_callbacks: 'logins/omniauth_callbacks'}
   post "/sign_up", to: "logins#sign_up"
   post "/sign_in", to: "auth#login"
end
