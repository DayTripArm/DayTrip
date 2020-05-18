class Login < ApplicationRecord
  has_one :profile
  accepts_nested_attributes_for :profile
  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = Login.where(email: data['email']).first
    user
  end
end
