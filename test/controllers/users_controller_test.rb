require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other_user = users(:jane)
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should get new' do
    get new_user_registration_path
    assert_response 200
  end

  test 'should redirect show when not logged in' do
    get user_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect edit when not logged in' do
    get edit_user_registration_path
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update when not logged in' do
    patch user_registration_path, params: { first_name: 'Jack' }
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end
end
