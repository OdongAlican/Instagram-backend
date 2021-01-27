# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :post
  mount_uploader :image, PhotoUploader
end
