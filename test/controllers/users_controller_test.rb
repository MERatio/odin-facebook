require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
  end

  test 'should show when not logged in' do
    get user_path(@user)
    assert_redirected_to new_user_session_path
  end
end
