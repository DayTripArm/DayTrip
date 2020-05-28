class ProfilesController < ApplicationController
  #TODO Albert: Add GET and POST methods to retrieve and update profile info
  def get_info
    if params[:profile] = 'personal'
      profile = Profile.select(Profile.attribute_names - ['login_id']).where(id: params[:id]).first
    elsif params[:profile] = 'payments'
      #TODO Albert: Add user payments info part
    else
      profile = nil
    end
    render json: { profile: profile }, status: :ok
  end

  def update_info
    if params[:profile] == 'personal'
      profile = Profile.where(id: params[:id]).first
      profile.update_attributes(profile_params)
      if !profile.save
        render json: { errors: profile.errors.full_messages }, status: :bad_request
      else
        render json: { message: "Profile info has been updated." }, status: :ok
      end
    elsif params[:profile] == 'login'
      login = Login.where(id: params[:id]).first
      login.update_attributes(password: params[:password])
      if !login.save
        render json: { errors: login.errors.full_messages }, status: :bad_request
      else
        render json: { message: "Password has been updated." }, status: :ok
      end
    elsif params[:profile] = 'payments'
      #TODO Albert: Add user payments info part
    else
      profile = nil
    end
  end

  def profile_params
    params.require(:personal).permit(:name, :gender, :date_of_birth, :phone, :about, :location, :languages, :work, :is_deactivated, :id)
  end
end
