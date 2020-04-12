class Login < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { !password.nil? }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = Login.where(email: data['email']).first
    user
  end
end
