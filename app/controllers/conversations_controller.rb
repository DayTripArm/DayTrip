class ConversationsController < ApplicationController
  # before_action :authenticate_user
  def index
    @conversations = Conversation.select("conversations.id as conversation_id, conversations.sender_id, conversations.recipient_id,
                                          booked_trips.pickup_location, booked_trips.pickup_time, booked_trips.trip_day, trips.title")
                         .joins(:booked_trip =>[:trip])
                         .where("sender_id = ? or recipient_id= ?",  params[:user_id], params[:user_id])
    conversations_list = JSON.parse(@conversations.to_json)
    render json: {conversations_list: conversations_list}, status: :ok
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

  def get_conversation_details
    @conversation = Conversation.where("id = ? ",  params[:id]).first
    @messages = @conversation.messages
    render json: {conversation: @conversation, messages: @messages}, status: :ok
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id, :booked_trip_id)
  end
end