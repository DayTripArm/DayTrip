class ProfilesController < ApplicationController
  #TODO Albert: Add GET and POST methods to retrieve and update profile info
  def get_info
    if params[:profile] == 'personal'
      profile = Login.exclude_fields.joins(:profile).where(id: params[:id]).first
    elsif params[:profile] == 'payments'
      #TODO Albert: Add user payments info part
    elsif params[:profile] == "user_profile"
      profile = {}
      joins = [:profile]
      select = 'logins.id, phone, profiles.name as user_name, email, about, location, languages, user_type, logins.created_at'

      if params[:user_type] == "2"
        joins.push(:driver_info, :photos)
        select += ", car_specs, car_seats, car_mark, car_model"
      end
      user_info = Login.select(select).joins(joins).where({id: params[:id]}).first

      if params[:user_type] == "2"
        profile = user_info.as_json
        car_photos = user_info.photos.where(file_type: 2)
        profile[:car_full_name] = CarHelper::format_car_model(user_info[:car_mark].to_i, user_info[:car_model].to_i)
        car_photos.each do |photo|
          photo.full_path = PhotosHelper::get_photo_full_path(photo.name,  Photo::FILE_TYPES.key(photo.file_type), user_info[:id])
        end
        profile[:car_photos] = car_photos
        profile[:reviews_rate] = user_info.driver_reviews.average(:rate) || "0.0"
        profile[:reviews_count] = user_info.driver_reviews.count()
        profile[:reviews] = user_info.driver_reviews
      else
        profile = user_info
      end
      profile_photo = user_info.photos.where(file_type: 1).first
      unless profile_photo.blank?
        profile_photo.full_path = PhotosHelper::get_photo_full_path(profile_photo.name,  Photo::FILE_TYPES.key(profile_photo.file_type), user_info[:id])
        profile[:profile_photo] = profile_photo.full_path
      end
    else
      profile = nil
    end
    render json: { profile: profile }, status: :ok
  end

  def update_info
    if params[:profile] == 'personal'
      profile = Profile.where(login_id: params[:id]).first
      profile.update_attributes(profile_params)
      if !profile.save
        render json: { errors: profile.errors.full_messages }, status: :bad_request
      else
        render json: { message: "Profile info has been updated." }, status: :ok
      end
    elsif params[:profile] == 'login'
      login = Login.where(id: params[:id]).first
      login.update_attributes(password: params[:profile_info][:password])
      if !login.save
        render json: { errors: login.errors.full_messages }, status: :bad_request
      else
        render json: { message: "Password has been updated." }, status: :ok
      end
    elsif params[:profile] == 'payments'
      #TODO Albert: Add user payments info part
    else
      profile = nil
    end
  end

  def profile_params
    params.require(:profile_info).permit(:name, :gender, :date_of_birth, :phone, :about, :location, :languages, :work, :is_deactivated, :id)
  end
end
