class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
  def index
    @messages = @conversation.messages
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true;
      end
    end
  end
  def new
    @message = @conversation.messages.new
  end
  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      render json: {message: "Message is saved"}, status: :ok
    end
  end
  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end