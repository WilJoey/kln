class PostsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user!, :except => [ :index, :show ]
  before_filter :get_post, :only => [ :edit, :update, :delete, :destroy ]

  def index
    @posts = Post.active.paginate :page => params[:page], :per_page => 5
    respond_with(@post) do |format|
      format.html { render @post }
      format.js   { render :layout => false}
    end
  end

  def show
    @post = Post.includes(:comments).active.find(params[:id])
    respond_with @post
  rescue
    redirect_to(posts_path, :notice => t("page.posts.not_found_msg"))
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      redirect_to(@post, :notice => t("page.posts.created_msg"))
    else
      render "new"
    end
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to(@post, :notice => t("page.posts.updated_msg"))
    else
      render "edit"
    end
  end

  def delete
  end

  def destroy
    redirect_to(@post) and return if params[:cancel]

    @post.destroy
    redirect_to posts_path
  end

  protected

  def get_post
    @post = Post.active.by_user(current_user).find(params[:id])
  rescue
    redirect_to(posts_path, :notice => t("page.posts.not_found_msg"))
  end
end

