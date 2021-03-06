# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name, :email, :password_digest
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  has_many :followers, through: :following_users
end
