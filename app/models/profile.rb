class Profile < ApplicationRecord
  belongs_to :login, optional: true
  validates_presence_of  :name, message: "cannot be blank"
end
