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
    if params[:profile] = 'personal'
      profile = Profile.update(params[:id], profile_params)
    elsif params[:profile] = 'payments'
      #TODO Albert: Add user payments info part
    else
      profile = nil
    end
    render json: { message: "Profile info updated." }, status: :ok
  end

  def profile_params
    params.require(:personal).permit(:name, :gender, :date_of_birth, :phone, :about, :location, :languages, :work, :is_deactivated, :id)
  end
end
