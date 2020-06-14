class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @strangers = User.strangers_for(current_user).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @post = current_user.posts.build
    @authored_posts = @user.posts.paginate(page: params[:page], per_page: 10)
  end

  def friends
    @user = User.find(params[:id])
    friends = @user.friends
    @friends_count = friends.count
    @friends = friends.paginate(page: params[:page])
    @title = "#{@user.first_name}'s" + ' ' + 'friend'.pluralize(@friends_count)
    render 'show_friends'
  end
end
