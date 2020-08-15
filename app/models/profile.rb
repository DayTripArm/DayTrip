class Profile < ApplicationRecord
  belongs_to :login, optional: true
  validates_presence_of  :name, message: "cannot be blank"
  scope :user_basic_info, -> { select("logins.id, logins.email, profiles.name").joins(:login) }
end
