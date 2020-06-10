class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
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
