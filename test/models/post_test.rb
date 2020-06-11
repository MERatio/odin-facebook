require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @john = users(:john)
    @post = @john.posts.build(content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @post.valid?
  end

  test 'author_id should be present' do
    @post.author_id = nil
    assert_not @post.valid?
  end

  test 'content should be present' do
    @post.content = '   '
    assert_not @post.valid?
  end

  test 'content should be at most 1000 characters' do
    @post.content = 'a' * 1001
    assert_not @post.valid?
  end

  test 'order should be most recent first' do
    assert_equal posts(:most_recent), Post.first
  end
end
