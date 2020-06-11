require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect index when not logged in' do
    get root_path
    assert_redirected_to new_user_session_path
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: 'Lorem ipsum' } }
    end
    assert_redirected_to new_user_session_path
  end
end
