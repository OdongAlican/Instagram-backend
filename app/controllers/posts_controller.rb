# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.all.limit(10).order('created_at DESC')
    @post = Post.new
    data = @posts.to_json({ include: %i[user photos] })
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

  private

  def post_params
    params.permit(:content)
  end
end
