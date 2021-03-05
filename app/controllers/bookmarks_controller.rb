# frozen_string_literal: true

class BookmarksController < ApplicationController
  def create
    @bookmark = current_user.bookmarks.build(bookmark_params)
    @post = @bookmark.post
    if @bookmark.save
      data = { message: 'Post bookmarked' }
      json_response(data, :created)
    else
      json_response({ message: 'Post already bookmarked' })
    end
  end

  def destroy
    @bookmark = bookmark.find(params[:id])
    @post = @bookmark.post
    if current_user.id == @bookmark.user_id
      if @bookmark.destroy
        json_response({ message: 'Post unbookmarked' }, :no_content)
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
