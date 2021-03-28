# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy

  has_many :likes, -> { order('created_at desc') }
  has_many :comments, -> { order('created_at desc') }
  has_many :bookmarks, -> { order('created_at desc') }

  def self.currentUserFollowers(id)
    user =  User.find(id)
    users = User.all
    users - user.followees
  end
end
