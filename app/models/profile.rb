class Profile < ApplicationRecord
  belongs_to :login
  validates_presence_of  :name, message: "cannot be blank"
end
