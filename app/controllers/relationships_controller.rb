class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    other_user = User.find(params[:other_user_id])
    current_user.send_friend_request_to(other_user)
    redirect_back(fallback_location: other_user)
  end

  def update
    other_user = Relationship.find(params[:id]).requestor
    current_user.accept_friend_request(other_user)
    redirect_back(fallback_location: other_user)
  end

  def destroy
    other_user = User.find(params[:other_user_id])
    current_user.destroy_relationship_with(other_user)
    redirect_back(fallback_location: other_user)
  end 
end
