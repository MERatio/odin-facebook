class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
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
