class Profile < ApplicationRecord
  belongs_to :login
  attr_accessor :name, :photo
  validates_presence_of  :name, message: "cannot be blank"
end
