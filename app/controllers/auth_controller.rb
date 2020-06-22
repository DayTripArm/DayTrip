class AuthController < ApplicationController
  def login
    user = Login.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      render json: payload(user)
    else
      render json: {errors: 'Invalid Username/Password'}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user and user.id
    {
        auth_token: JsonWebToken.encode({id: user.id, email: user.email}, 5.minutes.from_now),
        refresh_token: JsonWebToken.encode({id: user.id, email: user.email}, 15.minutes.from_now),
        user: {id: user.id, email: user.email, user_type: user.user_type}
    }
  end
end