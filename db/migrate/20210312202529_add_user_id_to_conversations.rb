# frozen_string_literal: true

class AddUserIdToConversations < ActiveRecord::Migration[6.0]
  def change
    add_column :conversations, :user_id, :integer
  end
end
