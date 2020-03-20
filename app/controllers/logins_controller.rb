class LoginsController < ApplicationController
  before_action :authenticate_request, except: :sign_up
  def index
    render json: {'logged_in' => true}
  end

  def sign_up
    user = Login.new(user_params)

    if user.save
      render json: {status: 'User created successfully'}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  private
  def user_params
    params.permit(:name, :email, :password, :login_type, :user_type)
  end
end
