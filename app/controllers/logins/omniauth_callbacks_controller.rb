class Logins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/logins.rb)
    auth_info = request.env["omniauth.auth"]
    @user = Login.from_omniauth(auth_info)
    if @user
      #sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      render json: { user: @user, messages: I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook') }
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      fb_info = {
          name: auth_info["info"]["name"],
          email: auth_info["info"]["email"],
          token: auth_info["credentials"]["token"]
      }
      render json: { fb_auth_data: fb_info}
    end
  end

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/logins.rb)
    @user = Login.from_omniauth(request.env["omniauth.auth"])
    if @user
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      render json: { user: @user, messages: flash[:notice] }
      #sign_in_and_redirect @user, event: :authentication
    else
      render json: { google_auth_data: request.env['omniauth.auth'].except(:extra)}
      #redirect_to new_login_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end


  def failure
    redirect_to root_path
  end
end