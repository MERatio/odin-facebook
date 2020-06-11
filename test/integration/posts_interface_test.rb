require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    sign_in(@user)
  end

  test 'invalid submission' do
    get root_path
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: '   ' } },
                       headers: { 'HTTP_REFERER': root_path }
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test 'valid submission' do
    get user_path(@user)
    request.env['HTTP_REFERER'] = user_path(@user)
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: 'Lorem ipsum' } },
                       headers: { 'HTTP_REFERER': user_path(@user) }
    end
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
  end
end
