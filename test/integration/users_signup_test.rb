require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get new_user_registration_path
    assert_template 'devise/registrations/new'
    assert_no_difference 'User.count' do
      assert_select 'form[action=?]', user_registration_path
      post user_registration_path, params: { user: { first_name: '',
                                                     last_name: '',
                                                     email: 'user@invalid',
                                                     password: 'foo',
                                                     password_confirmation: 'bar' } }
      assert_template 'devise/registrations/new'
      assert_select 'form[action=?]', user_registration_path
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
    end
  end

  test 'valid signup information' do
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { first_name: 'Example',
                                                     last_name: 'User',
                                                     email: 'user@example.com',
                                                     password: 'foobar',
                                                     password_confirmation: 'foobar' } }
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
