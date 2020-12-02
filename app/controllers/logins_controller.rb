class LoginsController < ApplicationController
  before_action :authenticate_request, except: [:sign_up]

  def sign_up
    if params[:user_type] == 2
      params[:is_prereg] = true
    end
    new_user = Login.new(login_params)
    new_user.build_profile(name: params[:name], phone: params[:phone])
    if new_user.save
      # if new_user.user_type == 1
      #   UserNotifierMailer.notify_travelers_prereg(new_user.id).deliver_later(wait: 30.seconds)
      # end
      render json: {email: new_user.email, confirmed_at: new_user.confirmed_at, user_type: new_user.user_type}, status: :ok
    else
      attrs = new_user.errors.messages.keys
      new_user.errors.messages.transform_values!.with_index { |msg, ind| ["#{attrs[ind].capitalize} #{msg[0]}"] }
      render json: { errors: new_user.errors.messages }, status: :bad_request
    end
  end

  private


  def login_params
    params.permit(:email, :password, :user_type, :is_prereg)
  end

  def payload(user)
    return nil unless user and user.id
    user_info = {id: user.id, name: user.profile.name, email: user.email, user_type: user.user_type}
    user_info[:is_prereg] = user.is_prereg if user.user_type == 2
    {
        auth_token: JsonWebToken.encode({id: user.id, email: user.email}, 5.minutes.from_now),
        refresh_token: JsonWebToken.encode({id: user.id, email: user.email}, 15.minutes.from_now),
        user: user_info
    }
  end
end
