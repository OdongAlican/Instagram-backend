# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name, :email, :password_digest
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
end
