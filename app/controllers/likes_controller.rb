# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
      # data = { message: 'Post Liked' }
      # json_response(data, :created)
      @posts = Post.all.limit(10).order('created_at DESC')
      nonFollowedList = Post.currentUserFollowers(current_user['id'])
      data = @posts.to_json({ include: ['user', 'photos',
                                        { likes: { include: 'user' } },
                                        { comments: { include: 'user' } },
                                        { bookmarks: { include: 'user' } }] })
  
      final = { data: data, followeesList: nonFollowedList }
      json_response(final, :created)
    else
      json_response({ message: 'Post already liked' })
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    if current_user.id == @like.user_id
      if @like.destroy
        # json_response({ message: 'Post disiked' }, :no_content)
        @posts = Post.all.limit(10).order('created_at DESC')
        nonFollowedList = Post.currentUserFollowers(current_user['id'])
        data = @posts.to_json({ include: ['user', 'photos',
                                          { likes: { include: 'user' } },
                                          { comments: { include: 'user' } },
                                          { bookmarks: { include: 'user' } }] })
    
        final = { data: data, followeesList: nonFollowedList }
        json_response(final, :created)
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
