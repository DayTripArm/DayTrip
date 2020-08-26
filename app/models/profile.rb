class Profile < ApplicationRecord
  belongs_to :login, optional: true
  validates_presence_of  :name, message: "cannot be blank"
  scope :user_basic_info, -> (login_id) { select("logins.id, logins.email, profiles.name").joins(:login).find_by(login_id: login_id) }
end
