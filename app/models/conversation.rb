# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :messagings
end