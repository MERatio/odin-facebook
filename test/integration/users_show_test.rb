require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other_user = users(:jane)
    sign_in(@user)
  end
  
  test 'own profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.first_name)
    assert_match @user.full_name, response.body
    assert_select 'a[href=?]', edit_user_registration_path(@user), 
      text: 'Edit information', count: 1
    assert_match @user.friends.count.to_s, response.body
    assert_select 'a[href=?]', friends_user_path(@user), count: 1
  end

  test 'other profile display' do
    get user_path(@other_user)
    assert_template 'users/show'
    assert_select 'title', full_title(@other_user.first_name)
    assert_match @other_user.full_name, response.body
    assert_select 'a[href=?]', edit_user_registration_path(@other_user), 
      text: 'Edit information', count: 0
    assert_match @other_user.friends.count.to_s, response.body
    assert_select 'a[href=?]', friends_user_path(@other_user), count: 1
  end
end
