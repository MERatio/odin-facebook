class PostsController < ApplicationController
  before_action :auth, only: [:index]

  def index
  end

  private

    def auth
      unless user_signed_in?
        redirect_to new_user_session_path
      end
    end
end
