require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
  end

  test 'pages for non-signed-in-users' do
    get root_path
    assert_select 'a[href=?]', root_path,
      text: 'Odin Facebook', count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', root_path,
      text: 'Home', count: 0
    assert_select 'ul.sent-friend-requests', count: 0
    assert_select 'ul.friend-requests', count: 0
    assert_select 'a[href=?]', destroy_user_session_path,
      text: 'Sign out', count: 0
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_select 'form#new_user[action=?]', user_session_path
  end

  test 'pages for signed-in-users' do
    sign_in(@user)
    get root_path
    assert_template 'posts/index'
    assert_select 'a[href=?]', root_path,
      text: 'Odin Facebook', count: 1
    assert_select 'a[href=?]', user_path(@user), count: 1
    assert_select 'a[href=?]', root_path,
      text: 'Home', count: 1
    assert_select 'ul.sent-friend-requests', count: 1
    assert_select 'ul.friend-requests', count: 1
    assert_select 'a[href=?]', destroy_user_session_path,
      text: 'Sign out', count: 1
  end
end
