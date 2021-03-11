class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
  def index
    auth_user = params[:user_id] #get authenticated user id
    @messages = @conversation.messages
    unless auth_user.nil?
      @messages.map { |message|message.update_attribute(:read, true) if message.login_id != auth_user.to_i}
    end
    render json: @messages, status: :ok
  end

  private
  def message_params
    params.require(:message).permit(:body, :login_id)
  end
end