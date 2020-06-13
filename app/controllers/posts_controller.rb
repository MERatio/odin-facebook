class PostsController < ApplicationController
  before_action :auth, only: [:index]
  before_action :authenticate_user!, except: [:index]

  def index
    @post = current_user.posts.build
    @news_feed_items = current_user.news_feed
                                   .paginate(page: params[:page], per_page: 10)
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = @post.comments.paginate(page: params[:page])
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.save ? flash[:success] = 'Post created' : error_flashes(@post)
    redirect_back(fallback_location: root_path)
  end

  private

    def auth
      unless user_signed_in?
        redirect_to new_user_session_path
      end
    end

    def post_params
      params.require(:post).permit(:content)
    end
end
