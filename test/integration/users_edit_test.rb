require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    sign_in(@user)
  end

  test 'unsuccessful edit' do
    get edit_user_registration_path
    assert_template 'devise/registrations/edit'
    assert_select 'title', full_title('Account update')
    assert_select 'form[action=?]', user_registration_path
    first_name = ''
    last_name = 'User'
    email = 'user@invalid'
    patch user_registration_path, params: { user: { first_name: first_name,
                                                    last_name: last_name,
                                                    email: email,
                                                    password: 'changepass',
                                                    password_confirmation: 'changepass',
                                                    current_password: 'wrongpass' } }
    assert_not_equal first_name, @user.first_name
    assert_not_equal last_name, @user.last_name
    assert_not_equal email, @user.email
    assert_template 'devise/registrations/edit'
    assert_select 'title', full_title('Account update')                      
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'successful edit' do
    get edit_user_registration_path
    first_name = 'Example'
    last_name = 'User'
    email = 'user@example.com'
    patch user_registration_path, params: { user: { first_name: first_name,
                                                    last_name: last_name,
                                                    email: email,
                                                    password: 'password',
                                                    password_confirmation: 'password',
                                                    current_password: 'foobar' } }
    @user.reload
    assert_equal first_name, @user.first_name
    assert_equal last_name, @user.last_name
    assert_equal email, @user.email
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
