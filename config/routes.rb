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

      #Fetch Country and Cities via API call
      get "/country_cities", to: "country_cities#index"

      # Driver Infos API calls routes
      post "/driver_infos", to: "driver_infos#create"
      get "/driver_infos/:id", to: "driver_infos#edit"
      put "/driver_infos/:id", to: "driver_infos#update"
      delete "/driver_infos/:id", to: "driver_infos#delete_photo"

      # Get lists from backoffice
      # Directions and tips lists
      get "/destinations", to: "destinations#index"
      get "/tips", to: "tips#index"

      # API to retrieve 'Heroes' and 'Hit the Road' section data(images and texts)
      get "/heroes", to: "home#heroes"
      get "/hit_the_road", to: "home#hit_the_road"
      get "/search_drivers", to: "home#search_drivers"

     # Get trips list
     get "/trips", to: "trips#index"
     get "/trips/:id", to: "trips#trip_individual"
     get "/trips/:id", to: "trips#trip_details"
     post "/trips/add_review", to: "trips#add_review"

     # Saved trips APIs
     post "/save_trip", to: "trips#save_unsave_trip"
     get "/saved_trips", to: "trips#get_saved_trips"

     post "/driver_reviews", to: "driver_reviews#create"

     # Calendar settings
     get "/calendar_settings/:id", to: "calendar_settings#edit"
     post "/calendar_settings/:id", to: "calendar_settings#create_update"

     # Booked trips
     get "/booked_trips", to: "booked_trips#index"
     post "/booked_trips", to: "booked_trips#create"
     get "/booked_trips/:id", to: "booked_trips#booked_trip_details"
   end
end
