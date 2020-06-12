class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: [:create, :destroy]

  def index
    post = Post.find_by(id: params[:post_id])
    post_reactions = post.reactions
    @post_reactions = post_reactions.paginate(page: params[:page])
  end

  def create
    current_user.likes(@post) unless current_user.likes?(@post)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.unlikes(@post) if current_user.likes?(@post)
    redirect_back(fallback_location: root_path)
  end

  private

    def find_post
      @post = Post.find(params[:post_id])
    end
end
