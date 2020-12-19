include ActionView::Helpers::NumberHelper
module TripsHelper
  def self.trip_reviews_count(reviews)
     reviews.count
  end

  def self.trip_reviews_rate(reviews)
    number_with_precision(reviews.average(:rate), :precision => 1) || nil
  end

  def self.is_favourite(trip, login_id)
    trip.saved_trips.where("saved_trips.login_id = ?", login_id).blank? ? false : true
  end

  def self.trip_reviews(reviews)
    trip_review = []
    reviews.each do |review|
      profile_photo = review.login.photos.where(file_type: 1).first
      unless profile_photo.blank?
        reviewer_img = PhotosHelper::get_photo_full_path(profile_photo.name,  Photo::FILE_TYPES.key(profile_photo.file_type), (review.has_attribute?(:traveler_id)? review.traveler_id: review.login_id).to_s)
        reviewer_img = File.join("/uploads","profile_photos","blank-profile.png") unless File.exists?(reviewer_img)
      else
        reviewer_img = File.join("/uploads","profile_photos","blank-profile.png")
      end
      trip_review << {
          review_text: review.review_text,
          reviewer_name: review.login.profile.name,
          reviewer_img: reviewer_img,
          created_at: review.created_at
      }
    end
    trip_review
  end

  def self.trip_destinations(trip)
    dests = []
    trip.destinations_in_trips.each do | trip_dest|
      dests << {
          stop_title: trip_dest.stops_title,
          dest_title: trip_dest.destination.nil? ? "" : trip_dest.destination.title,
          dest_desc: trip_dest.destination.nil? ? "" : trip_dest.destination.description,
          dest_image: trip_dest.destination.nil? ? "" : trip_dest.destination.image
      }
    end
    dests
  end
end
