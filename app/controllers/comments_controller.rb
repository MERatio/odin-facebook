class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(comment_params)
    comment.user = current_user
    comment.save ? flash[:success] = 'Comment created' : error_flashes(comment)
    redirect_back(fallback_location: root_path)
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
