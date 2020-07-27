class Login < ApplicationRecord
  has_one :profile
  has_one :driver_info
  has_many :photos
  has_many :saved_trips
  has_many :trips, through: :saved_trips
  accepts_nested_attributes_for :profile

  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }

  scope :exclude_fields, ->  { select( Login.attribute_names + Profile.attribute_names - [ 'login_id', 'password_digest', 'created_at', 'updated_at'] ) }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = Login.where(email: data['email']).first
    user
  end
end
