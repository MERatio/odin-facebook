require 'test_helper'

class FriendingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other_user = users(:jane)
  end

  test 'should send friend request the standard way' do
    sign_in(@user)
    assert_difference ['@user.sent_friend_requests.count', 
                       '@other_user.friend_requests.count'], 1 do
      post relationships_path, params: { other_user_id: @other_user.id }
    end
  end

  test 'should cancel friend request the standard way' do
    sign_in(@user)
    post relationships_path, params: { other_user_id: @other_user.id }
    friend_request = @user.sent_friend_requests.find_by(requestee_id: @other_user.id)
    assert_difference ['@user.sent_friend_requests.count',
                       '@other_user.friend_requests.count'], -1 do
      delete relationship_path(friend_request), 
        params: { other_user_id: @other_user.id }
    end
  end

  test 'should accept friend request the standard way' do
    sign_in(@other_user)
    post relationships_path, params: { other_user_id: @user.id }
    sign_out(@other_user)
    sign_in(@user)
    friend_request = @user.friend_requests
                          .find_by(requestor_id: @other_user.id)
    assert_difference ['@other_user.friends.count',
                       '@user.friends.count'], 1 do
      patch relationship_path(friend_request)
    end
  end

  test 'should reject friend request the standard way' do
    sign_in(@other_user)
    post relationships_path, params: { other_user_id: @user.id }
    sign_out(@other_user)
    sign_in(@user)
    friend_request = @user.friend_requests
                          .find_by(requestor_id: @other_user.id)
    assert_difference ['@other_user.sent_friend_requests.count',
                       '@user.friend_requests.count'], -1 do
      delete relationship_path(friend_request),
        params: { other_user_id: @other_user.id }
    end
  end

  test 'should unfriend a user the standard way' do
    # Send friend request and accept it
    sign_in(@other_user)
    post relationships_path, params: { other_user_id: @user.id }
    sign_out(@other_user)
    sign_in(@user)
    friend_request = @user.friend_requests
                          .find_by(requestor_id: @other_user.id)
    patch relationship_path(friend_request)
    # Unfriend
    assert_difference ['@other_user.friends.count',
                       '@user.friends.count'], -1 do
      delete relationship_path(friend_request),
        params: { other_user_id: @other_user.id }
    end
  end
end