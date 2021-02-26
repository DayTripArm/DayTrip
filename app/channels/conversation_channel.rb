class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ConversationChannel_#{params[:conversation_id]}"
  end
  def unsubscribed
    stop_all_streams
  end
  def create(options)
    message = Message.create(
        body: options.fetch('body'),
        conversation_id: options.fetch('conversation_id'),
        login_id: options.fetch('login_id')
    )
    if message.errors.present?
      transmit({type: "ConversationChannel_#{options.fetch('conversation_id')}", data: message.error.full_messages})
    else
      MessageBroadcastJob.perform_later(message)
    end
  end
end