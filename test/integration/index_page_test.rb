require 'test_helper'

class IndexPageTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    sign_in(@user)
  end

  test 'index page test' do
    get root_path
    assert_select 'form[action=?]', posts_path
  end
end
