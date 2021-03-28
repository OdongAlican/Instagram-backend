# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate
  # return auth token once user is authenticated
  def authenticate
    auth_token =
      AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    current_user =
      AuthenticateUser.new(auth_params[:email], auth_params[:password]).the_current_user

    response = { auth_token: auth_token, user: current_user }
    json_response(response)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
