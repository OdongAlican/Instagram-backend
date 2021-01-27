# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.all.limit(10).includes(:photos)
    @post = Post.new
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

  private

  def post_params
    params.permit(:content)
  end
end
