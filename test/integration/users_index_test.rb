require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    sign_in(@user)
  end

  test 'user index display' do
    get users_path
    strangers = User.strangers_for(@user)
    strangers.each do |stranger|
      assert_select 'img[alt=?]', stranger.full_name
      assert_match @user.full_name, response.body
      assert_select "div#friend-form-#{stranger.id}", count: 1
    end
  end
end
