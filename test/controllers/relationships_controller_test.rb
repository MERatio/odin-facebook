require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect create when not logged in' do
    post relationships_path, params: { params: { requestee_id: 2 } }
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update when not logged in' do
    patch relationship_path(relationships(:sue_friend_requests_john))
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy when not logged in' do
    delete relationship_path(relationships(:john_friends_with_user_0)),
           params: { other_user_id: users(:john).id } 
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end
end
