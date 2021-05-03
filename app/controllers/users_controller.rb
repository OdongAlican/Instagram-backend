# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorized, except: %i[create login]
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all.to_json({ include: %i[comments likes posts followees followers] })
    json_response(@users, :created)
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def show
    json_response(@user.to_json({ include: %i[comments likes posts followees followers] }))
  end

  def follow
    @followee = User.find(params[:id])

    if current_user.id != @followee.id
      current_user.followees << @followee
      @posts = Post.all.limit(10).order('created_at DESC')
      nonFollowedList = Post.currentUserFollowers(current_user['id'])
      data = @posts.to_json({ include: ['user', 'photos',
                                        { likes: { include: 'user' } },
                                        { comments: { include: 'user' } },
                                        { bookmarks: { include: 'user' } }] })
      final = { data: data, followeesList: nonFollowedList }
      json_response(final, :created)
    else
      json_response({ message: 'You cannot follow yourself' }, :unauthorized)
    end
  end

  def peopleToFollow
    result = User.nonFollowers(current_user.id)
    json_response(result, :created)
  end

  def unfollow
    @followee = User.find(params[:id])
    if current_user.id != @followee.id
      current_user.followed_users.find_by(followee_id: @followee.id).destroy
      json_response(@followee)
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
