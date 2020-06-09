require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
    @other_user = users(:jane)
    @relationship = Relationship.new(requestor_id: @user.id,
                                     requestee_id: @other_user.id)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'should require a requestor_id' do
    @relationship.requestor_id = nil
    assert_not @relationship.valid?
  end

  test 'should require a requestee_id' do
    @relationship.requestee_id = nil
    assert_not @relationship.valid?
  end

  test 'requestor_id and requestee_id pair should be unique' do
    @relationship.save
    same_relationship = Relationship.new(requestor_id: @user.id,
                                         requestee_id: @other_user.id)
    inverse_same_relationship = Relationship.new(requestor_id: @other_user.id,
                                                 requestee_id: @user.id)
    assert_not same_relationship.valid?
    assert_not inverse_same_relationship.valid?
  end
  
  test 'requestor_id and requestee_id should not be the same' do
    @relationship.requestee_id = @user.id
    assert_not @relationship.valid?
  end
end
