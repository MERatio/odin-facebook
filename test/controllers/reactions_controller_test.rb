require 'test_helper'

class ReactionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @post = posts(:cats)
  end

  test 'should redirect index when not logged in' do
    get post_reactions_path(@post)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect create when not logged in' do
    post post_reactions_path(@post)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy when not logged in' do
    sign_in(@user)
    post post_reactions_path(@post)
    assert @post.reactions.exists?(user_id: @user.id)
    sign_out(@user)
    reaction = @post.reactions.find_by(user_id: @user.id)
    delete post_reaction_path(@post, reaction)
    assert_redirected_to new_user_session_path
  end
end
