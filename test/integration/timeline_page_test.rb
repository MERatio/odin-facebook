require 'test_helper'

class TimelinePageTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    sign_in(@user)
  end

  test 'timeline display' do
    get root_path
    assert_select 'section.post-form', count: 1
  end
end
