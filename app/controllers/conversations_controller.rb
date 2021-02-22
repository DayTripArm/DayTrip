class ConversationsController < ApplicationController
  # before_action :authenticate_user
  def index
    join_str = "JOIN profiles on (profiles.id = sender_id or profiles.id = recipient_id) and profiles.id <> #{params[:user_id]}
                JOIN photos on (photos.login_id = sender_id or photos.login_id = recipient_id) and photos.login_id <> #{params[:user_id]} and file_type=1"
    @conversations = Conversation.select("conversations.id, conversations.sender_id, conversations.recipient_id, conversations.booked_trip_id,
                                          booked_trips.pickup_location, booked_trips.pickup_time, booked_trips.trip_day, trips.title,
                                          profiles.id as user_id, profiles.name as recipient_name, photos.name as recipient_img")
                         .joins(:booked_trip =>[:trip])
                         .joins(join_str)
                         .where("#{params[:contact_name].blank? ? "" : "profiles.name ilike '%#{params[:contact_name]}%' and "} sender_id = ? or recipient_id= ?",  params[:user_id], params[:user_id])
    conversations_list = JSON.parse(@conversations.to_json)
    conversations_list.each do |conversation|
      conversation["recipient_img"] = conversation["recipient_img"].blank? ? File.join("/uploads","profile_photos","blank-profile.png") :
                                          PhotosHelper::get_photo_full_path(conversation["recipient_img"], "profile_photos", conversation["user_id"].to_s)
    end
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
    params.require(:conversation).permit(:sender_id, :recipient_id, :booked_trip_id)
  end
end