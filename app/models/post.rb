# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy

  has_many :likes, -> { order('created_at desc') }
  has_many :comments, -> { order('created_at desc') }
  has_many :bookmarks, -> { order('created_at desc') }

  def is_liked(user)
    Like.find_by(user_id: user.id, post_id: id)
  end

  def is_bookmarked(user)
    Bookmark.find_by(user_id: user.id, post_id: id)
  end
end
