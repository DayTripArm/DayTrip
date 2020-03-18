class AuthController < ApplicationController
  def verify_user
    user = Logins.where(email: params[:email])
    if user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: {errors: 'Invalid Username/Password'}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user and user.id
    {
        auth_token: JsonWebToken.encode({user_id: user.id}),
        user: {id: user.id, email: user.email}
    }
  end
end