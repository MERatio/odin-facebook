require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect index when not logged in' do
    get root_path
    assert_redirected_to new_user_session_path
  end
end
