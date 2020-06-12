require 'test_helper'

class ReactionTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
    @post = posts(:jane_post_1)
    @reaction = @user.reactions.build(post_id: @post.id)
  end

  test 'should be valid' do
    assert @reaction.valid?
  end

  test 'user_id should be present' do
    @reaction.user_id = nil
    assert_not @reaction.valid?
  end

  test 'post_id should be present' do
    @reaction.post_id = nil
    assert_not @reaction.valid?
  end

  test 'user_id and post_id pair should be unique' do
    @reaction.save
    same_reaction = @user.reactions.build(post_id: @post.id)
    assert_not same_reaction.valid?
  end

  test 'order should be most recent first' do
    assert_equal reactions(:most_recent), Reaction.first
  end
end
