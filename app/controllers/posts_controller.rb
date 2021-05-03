# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :find_post, only: %i[show destroy]

  def index
    @posts = Post.all.limit(10).order('created_at DESC')
    nonFollowedList = Post.currentUserFollowers(current_user['id'])
    data = @posts.to_json({ include: ['user', 'photos',
                                      { likes: { include: 'user' } },
                                      { comments: { include: 'user' } },
                                      { bookmarks: { include: 'user' } }] })

    final = { data: data, followeesList: nonFollowedList }
    json_response(final, :created)
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
    @result = @post.to_json({ include: ['photos',
                                        { likes: { include: 'user' } },
                                        { user: { include: [{
                                          posts: { include: %w[comments likes] }
                                        }, 'followers'] } },
                                        { comments: { include: 'user' } },
                                        { bookmarks: { include: 'user' } }] })
    json_response(@result, :created)
  end

  def destroy
    if @post.user = current_user
      if @post.destroy
        data = { 'message' => 'post destroyed' }
        json_response(data, :no_content)
      else
        data = { 'message' => 'Something went wrong' }
        json_response(data, :no_content)
      end
    else
      data = { message: 'Not Authorized' }
      json_response(data, :unauthorized)
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
