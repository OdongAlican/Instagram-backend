# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :find_post, only: %i[show destroy]

  def index
    @posts = Post.all.limit(10).order('created_at DESC')
    @post = Post.new
    data = @posts.to_json({ include: %i[user photos likes] })
    json_response(data, :created)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      params[:images]&.each do |img|
        @post.photos.create(image: img)
      end
      json_response(@post, :created)
    else
      error = 'Invalid username or password'
      json_response(error, :unprocessable_entity)
    end
  end

  def show
    # @photos = @post.photos
    # @likes = @post.likes.to_json({ include: ['user'] })
    @is_liked = @post.is_liked(current_user)
    @result = @post.to_json({ include: %w[user likes photos] })
    json_response(@result, :created)
  end

  def destroy
    if @post.user = current_user
      if @post.destroy
        data = { 'message' => 'post destroyed' }
        return json_response(data, :no_content)
      else
        data = { 'message' => 'Something went wrong' }
        return json_response(data, :no_content)
      end
    else
      data = { message: "You don't have permission to delete this Post" }
      return json_response(data, :no_content)
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:content)
  end
end
