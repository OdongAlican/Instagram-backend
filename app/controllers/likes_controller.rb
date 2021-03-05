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
    if current_user.id == @like.user_id
      if @like.destroy
        json_response({ message: 'Post disiked' }, :no_content)
      else
        json_response({ message: 'Something went wrong' })
      end
    else
      json_response({ message: 'Not Authorized' }, :unauthorized)
    end
  end

  private

  def like_params
    params.permit(:post_id)
  end
end
