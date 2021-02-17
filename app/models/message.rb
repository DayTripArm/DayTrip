class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :login
  validates_presence_of :body, :conversation_id, :login_id


  def message_time
    created_at.strftime("%FT%T")
  end
end