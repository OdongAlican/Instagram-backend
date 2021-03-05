# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      @post = @comment.post
      json_response(@post.to_json({ include: 'comments' }), :created)
    else
      json_response({ message: 'Something went Wrong' }, :no_content)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    if current_user.id == @comment.user_id
      if @comment.destroy
        json_response({ message: 'Comment destroyed' }, :no_content)
      else
        json_response({ message: 'Something went Wrong' }, :no_content)
      end
    else
      json_response({ message: 'Not authorized' }, :unauthorized)
    end
  end

  private

  def comment_params
    params.required(:comment).permit :user_id, :post_id, :content
  end
end