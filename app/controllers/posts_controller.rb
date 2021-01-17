class PostsController < ApplicationController
  before_action :authorize_access_request!, except: [:index, :show]
  before_action :set_post, only: [:update, :destroy]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show
    @post = Post.friendly.find(params[:id])
    render json: @post
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)

    @post.save!
    render json: @post, status: :created, location: @post
  rescue
      render json: { errors: @post.errors, messages: @post.errors.full_messages }, status: :unprocessable_entity
  end

  # PATCH/PUT /posts/1
  def update
    @post.update!(post_params)
    render json: @post
  rescue
    render json: { errors: @post.errors, messages: @post.errors.full_messages }, status: :unprocessable_entity
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private

  def set_post
    @post = current_user.posts.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :summary, :content, :cover_url)
  end
end