class LoginsController < ApplicationController
  before_action :authenticate_request, except: [:sign_up]

  def sign_up
    new_user = Login.new(login_params)
    new_user.build_profile({name: params[:name], phone: params[:phone]})
    if new_user.save
      render json: {status: 'User created successfully'}, status: :created
    else
      render json: { errors: new_user.errors.full_messages }, status: :bad_request
    end
  end

  private


  def login_params
    params.require(:login).permit(:email, :password, :user_type, :profiles => [:name, :phone])
  end
end
