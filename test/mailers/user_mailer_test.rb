require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'welcome email' do
    user = users(:john)
    mail = UserMailer.with(user: user).welcome_email
    assert_equal [ENV['FROM_EMAIL']], mail.from
    assert_equal 'Welcome to Odin Facebook',          mail.subject
    assert_equal [user.email],                        mail.to
    assert_match user.first_name,                     mail.body.encoded
    sign_up_url = 'https://odin-facebook-54888.herokuapp.com/users/sign_in'
    assert_match sign_up_url,                         mail.body.encoded
  end
end
