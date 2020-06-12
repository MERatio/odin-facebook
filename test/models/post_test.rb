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

  test 'associated reactions should be destroyed' do
    jane_post = posts(:jane_post_1)
    @john.reactions.create!(post_id: jane_post.id)
    assert jane_post.reactions.count > 0
    assert_difference 'Reaction.count', -jane_post.reactions.count do
      jane_post.destroy
    end
  end
end
