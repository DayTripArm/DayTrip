class Conversation < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'Login'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'Login'
  belongs_to :booked_trip
  has_many :messages, dependent: :destroy
  # TODO Improve validation
  #validates_uniqueness_of :sender_id, :scope => :recipient_id
  scope :between, -> (sender_id,recipient_id, booked_trip_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =? AND conversations.booked_trip_id =?) OR
           (conversations.recipient_id = ? AND conversations.sender_id =? AND conversations.booked_trip_id =?)",
          sender_id,recipient_id, booked_trip_id,
          sender_id,recipient_id, booked_trip_id)
  end
end