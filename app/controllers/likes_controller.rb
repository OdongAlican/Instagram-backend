# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
      data = { message: 'Post Liked' }
      json_response(data, :created)
    else
      json_response({ message: 'Post already liked' })
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    data = { message: 'Post disiked' }
    json_response(data, :no_content) if @like.destroy
  end

  private

  def like_params
    params.permit(:post_id)
  end
end
