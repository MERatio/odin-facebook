require 'test_helper'

class UsersShowFriendsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other_user = users(:jane)
    sign_in(@user)
  end
  
  test 'own friends page' do
    get friends_user_path(@user)
    assert_template 'users/show_friends'
    assert_match @user.full_name, response.body
    assert_match @user.friends.count.to_s, response.body
    assert_not @user.friends.empty?
    @user.friends.paginate(page: 1).each do |friend|
      assert_select 'a[href=?]', user_path(friend), text: friend.full_name
    end
    assert_select 'div.pagination'
  end

  test 'other friends page' do
    get friends_user_path(@other_user)
    assert_template 'users/show_friends'
    assert_match @other_user.full_name, response.body
    assert_match @other_user.friends.count.to_s, response.body
    assert_not @other_user.friends.empty?
    @other_user.friends.paginate(page: 1).each do |friend|
      assert_select 'a[href=?]', user_path(friend), text: friend.full_name
    end
    assert_select 'div.pagination'
  end
end
