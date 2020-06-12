require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
    @post = posts(:jane_post_1)
    @comment = @user.comments.build(post_id: @post.id, 
                                    content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @comment.valid?
  end

  test 'user_id should be present' do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test 'post_id should be present' do
    @comment.post_id = nil
    assert_not @comment.valid?
  end

  test 'content should be present' do
    @comment.content = '   '
    assert_not @comment.valid?
  end

  test 'content should be at most 200 characters' do
    @comment.content = 'a' * 201
    assert_not @comment.valid?
  end

  test 'order should be most recent first' do
    assert_equal comments(:most_recent), Comment.first
  end
end
