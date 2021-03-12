# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :set_user, only: %i[show update destroy follow unfollow]
  # POST /signup
  # return authenticated token upon signup
  def index
    @users = User.all.to_json({ include: %i[comments likes posts followees followers] })
    json_response(@users, :created)
  end

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token, user: user }
    json_response(response, :created)
  end

  def show
    json_response(@user.to_json({ include: %i[followees followers] }))
  end

  def follow
    if current_user.id != @user.id
      current_user.followees << @user
      json_response(@user, :created)
    else
      json_response({ message: 'You cannot follow yourself' }, :unauthorized)
    end
  end

  def unfollow
    if current_user.id != @user.id
      current_user.followed_users.find_by(followee_id: @user.id).destroy
      json_response(@user)
    else
      json_response({ message: 'You cannot unfollow yourself' }, :unauthorized)
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def set_user
    @user = User.find(params[:id])
  end
end
