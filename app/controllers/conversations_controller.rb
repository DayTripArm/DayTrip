class ConversationsController < ApplicationController
  # before_action :authenticate_user
  def index
    @conversations = Conversation.select("conversations.id as conversation_id, conversations.sender_id, conversations.recipient_id, booked_trips.*").joins(:booked_trip)
                         .where("sender_id = ? or recipient_id= ?",  params[:user_id], params[:user_id])

    render json: {conversations: @conversations}, status: :ok
  end
  def create
    if Conversation.between(params[:sender_id],params[:recipient_id], params[:booked_trip_id])
           .present?
      @conversation = Conversation.between(params[:sender_id],
                                           params[:recipient_id], params[:booked_trip_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    render json: {conversation: @conversation}, status: :ok
  end
  private
  def conversation_params
    params.permit(:sender_id, :recipient_id, :booked_trip_id)
  end
end