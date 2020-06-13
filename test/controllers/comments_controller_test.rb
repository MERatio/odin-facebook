require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:jane_post_1)
  end

  test 'should redirect create when not logged in' do
    post post_comments_path(@post), params: { content: 'Lorem ipsum' }
    assert_redirected_to new_user_session_path
  end
end
