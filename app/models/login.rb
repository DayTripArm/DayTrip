class Login < ApplicationRecord
  devise :confirmable

  has_one :profile
  has_one :driver_info
  has_many :photos
  has_many :saved_trips
  has_many :trips, through: :saved_trips
  has_many :trip_reviews
  has_many :driver_booked_trips, class_name: 'BookedTrip', foreign_key: :driver_id
  has_many :traveler_booked_trips, class_name: 'BookedTrip', foreign_key: :traveler_id
  has_one :calendar_setting, :foreign_key => "driver_id"
  has_many :driver_reviews, :foreign_key => "driver_id"
  accepts_nested_attributes_for :profile

  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true, if: Proc.new { |user| user.confirmed_at.blank? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: Proc.new{ |user| user.confirmed_at.blank? }
  validates :password, length: { minimum: 6 }, if: Proc.new { |user| user.confirmed_at.blank? }

  scope :exclude_fields, ->  { select( Login.attribute_names + Profile.attribute_names - [ 'login_id', 'password_digest', 'created_at', 'updated_at'] ) }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = Login.where(email: data['email']).first
    user
  end
end
