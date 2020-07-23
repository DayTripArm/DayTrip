Rails.application.routes.draw do
   devise_for :admin_users, ActiveAdmin::Devise.config
   ActiveAdmin.routes(self)

   scope "api" do
      # SignUp and SignIn API calls routes
      post "/sign_up", to: "logins#sign_up"
      post "/sign_in", to: "auth#login"

      # Profile API calls routes
      get "/profile_info/:id", to: "profiles#get_info"
      post "/profile_info/:id", to: "profiles#update_info"

      # Car brands API calls routes
      get "/car_brands", to: "car_brands#index"
      get "/car_brands/:id/models", to: "car_brands#get_car_models"

      # Driver Infos API calls routes
      post "/driver_infos", to: "driver_infos#create"
      get "/driver_infos/:id", to: "driver_infos#edit"
      put "/driver_infos/:id", to: "driver_infos#update"

      # Get lists from backoffice
      # Directions and tips lists
      get "/destinations", to: "destinations#index"
      get "/tips", to: "tips#index"

      # API to retrieve 'Heroes' and 'Hit the Road' section data(images and texts)
      get "/heroes", to: "home#heroes"
      get "/hit_the_road", to: "home#hit_the_road"

     # Get trips list
     get "/trips", to: "trips#index"
     get "/trips/:id", to: "trips#trip_detail"
   end
end
