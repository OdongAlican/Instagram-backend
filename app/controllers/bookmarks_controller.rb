# frozen_string_literal: true

class BookmarksController < ApplicationController
  def create
    @bookmark = current_user.bookmarks.build(bookmark_params)
    @post = @bookmark.post
    if @bookmark.save
      @posts = Post.all.limit(10).order('created_at DESC')
      nonFollowedList = Post.currentUserFollowers(current_user['id'])
      data = @posts.to_json({ include: ['user', 'photos',
                                        { likes: { include: 'user' } },
                                        { comments: { include: 'user' } },
                                        { bookmarks: { include: 'user' } }] })

      final = { data: data, followeesList: nonFollowedList }
      json_response(final, :created)
    else
      json_response({ message: 'Post already bookmarked' })
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @post = @bookmark.post
    if current_user.id == @bookmark.user_id
      if @bookmark.destroy
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

  def bookmark_params
    params.permit(:post_id)
  end
end
