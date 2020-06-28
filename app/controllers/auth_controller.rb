class AuthController < ApplicationController
  def login
      user = Login.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        render json: payload(user), status: :ok
      elsif user && !user.authenticate(params[:password])
        render json: {errors: { password: I18n.t('sign_in.incorrect_password') }}, status: :unauthorized
      else
        render json: {errors: { general: I18n.t('sign_in.incorrect_creds') }}, status: :unauthorized
      end
  end

  private

  def payload(user)
    return nil unless user and user.id
    user_info = {id: user.id, email: user.email, user_type: user.user_type}
    user_info[:is_prereg] = user.is_prereg if user.user_type == 2
    {
        auth_token: JsonWebToken.encode({id: user.id, email: user.email}, 5.minutes.from_now),
        refresh_token: JsonWebToken.encode({id: user.id, email: user.email}, 15.minutes.from_now),
        user: user_info
    }
  end
end