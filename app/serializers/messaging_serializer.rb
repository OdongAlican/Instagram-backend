# frozen_string_literal: true

class MessagingSerializer < ActiveModel::Serializer
  attributes :id, :conversation_id, :text, :created_at
end
