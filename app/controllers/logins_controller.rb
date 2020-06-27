class LoginsController < ApplicationController
  before_action :authenticate_request, except: [:sign_up]

  def sign_up
    if params[:user_type] == 2
      params[:is_prereg] = true
    end
    new_user = Login.new(login_params)
    new_user.build_profile(name: params[:name], phone: params[:phone])
    if new_user.save
      render json: {status: 'User created successfully', payload: payload(new_user)}, status: :created
    else
      render json: { errors: new_user.errors.full_messages }, status: :bad_request
    end
  end

  private


  def login_params
    params.permit(:email, :password, :user_type, :is_prereg)
  end

  def payload(user)
    return nil unless user and user.id
    {
        auth_token: JsonWebToken.encode({id: user.id, email: user.email}, 5.minutes.from_now),
        refresh_token: JsonWebToken.encode({id: user.id, email: user.email}, 15.minutes.from_now),
        user: {id: user.id, email: user.email, user_type: user.user_type}
    }
  end
end
