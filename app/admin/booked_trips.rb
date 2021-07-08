ActiveAdmin.register BookedTrip do
  actions :index, :show, :destroy
  index do
    column "Trip Name" do |res|
      res.trip.title
    end
    column :promo_code
    column :trip_day
    actions
  end

  filter :trip_day
  filter :promo_code


  show do
    attributes_table do
      row "Trip Name" do |res|
        res.trip.title
      end
      row "Driver Name" do |res|
        res.driver.profile.name
      end
      row "Traveler Name" do |res|
        res.traveler.profile.name
      end
      row :pickup_location
      row :promo_code
      row :trip_day
    end
  end

end
