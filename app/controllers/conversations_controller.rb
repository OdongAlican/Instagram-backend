# frozen_string_literal: true

class ConversationsController < ApplicationController
  def index
    conversations = Conversation.all
    # render json: conversations
    data = conversations.to_json({ include: %w[user messagings] })
    render json: data
  end

  def create
    conversation = current_user.conversations.build(conversation_params)
    # conversation = Conversation.new(conversation_params)
    if conversation.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        ConversationSerializer.new(conversation)
      ).serializable_hash
      ActionCable.server.broadcast 'conversations_channel', serialized_data
      head :ok
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:title, :reciever_id, :user_id)
  end
end
