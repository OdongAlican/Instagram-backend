# frozen_string_literal: true

class MessagingsController < ApplicationController
  def create
    message = Messaging.new(message_params)
    conversation = Conversation.find(message_params[:conversation_id])
    if message.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        MessagingSerializer.new(message)
      ).serializable_hash
      MessagingsChannel.broadcast_to conversation, serialized_data
      head :ok
    end
  end

  private

  def message_params
    params.require(:messaging).permit(:text, :conversation_id)
  end
end
