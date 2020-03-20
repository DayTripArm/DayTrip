Rails.application.routes.draw do
   post "/sign_up", to: "logins#sign_up"
   post "/sign_in", to: "auth#login"
end
