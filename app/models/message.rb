class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :login
  validates_presence_of :body, :conversation_id, :login_id
  default_scope { order("created_at ASC") }

  def message_time
    created_at.strftime("%FT%T")
  end
end