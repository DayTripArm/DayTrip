class AuthController < ApplicationController
  def login
    unless params[:confirmation_token].blank?
      confirm_account
    else
      user = Login.joins(:profile).select("logins.*, profiles.name").find_by(email: params[:email])
      unless user.blank?
        if user.confirmed_at.blank?
          render json: {user: {email: user.email, confirmed_at: user.confirmed_at}}, status: :ok
        else
          if user.authenticate(params[:password])
            render json: payload(user), status: :ok
          elsif !user.authenticate(params[:password])
            render json: {errors: { password: I18n.t('sign_in.incorrect_password') }}, status: :unauthorized
          else
            render json: {errors: { general: I18n.t('sign_in.incorrect_creds') }}, status: :unauthorized
          end
        end
      else
        render json: {errors: { general: I18n.t('sign_in.incorrect_creds') }}, status: :unauthorized
      end
    end
  end

  def confirm_account
      user = Login.where(confirmation_token: params[:confirmation_token]).first
      unless user.blank?
        if user.confirmed_at.blank?
          user.confirmed_at = DateTime.now
          user.save!
        end
        render json: payload(user), status: :ok
      else
        render json: {user: {}}, status: :ok
      end
  end

  private

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