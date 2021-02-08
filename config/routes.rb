Rails.application.routes.draw do
   devise_for :admin_users, :logins,  ActiveAdmin::Devise.config
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
      get "/driver_progress", to: "driver_infos#driver_progress"
      get "/view_driver_progress", to: "driver_infos#view_driver_progress"

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

     # Saved trips APIs
     post "/save_trip", to: "trips#save_unsave_trip"
     get "/saved_trips", to: "trips#get_saved_trips"

     get "/price_list", to: "home#price_list"

     # Calendar settings
     get "/calendar_settings/:id", to: "calendar_settings#edit"
     post "/calendar_settings/:id", to: "calendar_settings#create_update"

     # Booked trips
     get "/booked_trips", to: "booked_trips#index"
     post "/booked_trips", to: "booked_trips#create"
     get "/booked_trips/:id", to: "booked_trips#booked_trip_details"

      post "/trip_review", to: "reviews#trip_review"
      post "/driver_review", to: "reviews#driver_review"
     # Resend confirmation email
     get "/resend_confirmation", to: "auth#resend_confirmation"
      # Messages
      get "conversations", to: "conversations#index"
      post "conversations", to: "conversations#create"

      get "messages/:conversation_id", to: "messages#index"
      post "messages/:conversation_id", to: "messages#create"
   end
end
