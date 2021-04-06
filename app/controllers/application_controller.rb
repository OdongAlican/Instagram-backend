# frozen_string_literal: true

class ApplicationController < ActionController::API
  # before_action :authorized

  include Response
  include ExceptionHandler

  @@newguy = ''

  def encode_token(payload)
    JWT.encode(payload, 's3cr3t')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(@token, 's3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def sample(user)
    @@newguy = user
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @@newguy = User.find_by(id: user_id)
    else
      @@newguy
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end
