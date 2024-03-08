class PostsController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_user!
  def index
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      # Post to Facebook
      post_to_facebook(@post)
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end


  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:title, :descriptions)
  end

  def post_to_facebook(post)
    user = post.user
    graph = Koala::Facebook::API.new(user.access_token)
    g =  graph.get_connections("me", "friends")
    byebug
    graph.put_connections('me', 'feed', message: post.title, description: post.descriptions)
  end
end
