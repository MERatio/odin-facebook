require 'test_helper'

class CommentsInterface < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @jane_post = posts(:jane_post_1)
    sign_in(@user)
  end

  test 'should comment to a post the standard way' do
    assert_difference '@jane_post.comments.count' do
      post post_comments_path(@jane_post), 
           params: { comment: { content: 'Lorem ipsum' } }
    end
  end
end
