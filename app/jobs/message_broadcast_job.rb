class MessageBroadcastJob < ApplicationJob
  queue_as :messages
  def perform(message)
    ActionCable
        .server
        .broadcast("ConversationChannel_#{message.conversation_id}",
                   id: message.id,
                   conversation_id: message.conversation_id,
                   login_id: message.login_id,
                   read: message.read,
                   body: message.body)
  end
end
