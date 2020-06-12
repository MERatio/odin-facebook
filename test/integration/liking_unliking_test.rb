require 'test_helper'

class LikingUnlikingTest < ActionDispatch::IntegrationTest
    def setup
    @user = users(:john)
    @post = posts(:jane_post_1)
    sign_in(@user)
  end

  test 'should like a post the standard way' do
    assert_difference '@post.reactions.count', 1 do
      post post_reactions_path(@post)
    end
  end

  test 'should unlike a post the standard way' do
    post post_reactions_path(@post)
    assert @post.reactions.exists?(user_id: @user.id)
    assert_difference '@post.reactions.count', -1 do
      reaction = @post.reactions.find_by(user_id: @user.id)
      delete post_reaction_path(@post, reaction)
    end
  end
end
