require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: 'Example', last_name: 'User', 
                     email: 'user@example.com', password: 'foobar',
                     password_confirmation: 'foobar')
    @john = users(:john)
    @hans = users(:hans)
    @jane_post = posts(:jane_post_1)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'first_name should be present' do
    @user.first_name = '   '
    assert_not @user.valid?
  end

  test 'first_name should not be too long' do
    @user.first_name = 'a' * 31
    assert_not @user.valid?
  end
    
  test 'first_name validation should accept valid first_name' do
    first_names = ['John', 'Juan', 'Foo Bar']
    first_names.each do |first_name|
      @user.first_name = first_name
      assert @user.valid?, "#{first_name.inspect} should be valid"
    end
  end

  test 'first_name validation should reject invalid first_name' do
    first_names = ['John123', 'Juan123', 'Foo Baz123']
    first_names.each do |first_name|
      @user.first_name = first_name
      assert_not @user.valid?, "#{first_name.inspect} should be invalid"
    end
  end

  test 'last_name should be present' do
    @user.last_name = '   '
    assert_not @user.valid?
  end

  test 'last_name should not be too long' do
    @user.last_name = 'a' * 21
    assert_not @user.valid?
  end

  test 'last_name validation should accept valid last_name' do
    last_names = ['Doe', 'Dela Cruz', 'Baz']
    last_names.each do |last_name|
      @user.last_name = last_name
      assert @user.valid?, "#{last_name.inspect} should be valid"
    end
  end

  test 'last_name validation should reject invalid last_name' do
    last_names = ['Doe123', 'Dela Cruz123', 'Baz123']
    last_names.each do |last_name|
      @user.last_name = last_name
      assert_not @user.valid?, "#{last_name.inspect} should be invalid"
    end
  end

  test 'full_name should be present' do
    @user.valid?
    assert_not @user.full_name.blank?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be saved as lowercase' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password and password_confirmation should be present' do
    @user.password = @user.password_confirmation = '   '
    assert_not @user.valid?
  end

  test 'password and password_confirmation should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'password and password_confirmation should have a maximum length' do
    @user.password = @user.password_confirmation = 'a' * 19
    assert_not @user.valid?
  end

  test 'associated relationships should be destroyed' do
    relationship_count = @john.relationships.count +
                         @john.inverse_relationships.count
    assert relationship_count > 0
    assert_difference 'Relationship.count', -relationship_count do
      @john.destroy
    end
  end
  
  test 'should send and cancel friend request to a user' do
    @john.send_friend_request_to(@hans)
    assert @john.requestees.include?(@hans)
    assert @hans.requestors.include?(@john)
    @john.destroy_relationship_with(@hans)
    assert_not @john.requestees.include?(@hans)
    assert_not @hans.requestors.include?(@john)
  end

  test 'should accept and reject friend request of other user' do
    @john.send_friend_request_to(@hans)
    assert_not @john.friends_with?(@hans)
    assert_not @hans.friends_with?(@john)
    assert @hans.destroy_relationship_with(@john)
    assert_not @john.requestees.include?(@hans)
    assert_not @hans.requestors.include?(@john)
    @john.send_friend_request_to(@hans)
    @hans.accept_friend_request(@john)
    assert_not @john.requestees.include?(@hans)
    assert_not @hans.requestors.include?(@john)
    assert @john.friends_with?(@hans)
    assert @hans.friends_with?(@john)
  end

  test 'should unfriend a user' do
    @john.send_friend_request_to(@hans)
    assert_not @john.friends_with?(@hans)
    assert_not @hans.friends_with?(@john)
    @hans.accept_friend_request(@john)
    assert @john.friends_with?(@hans)
    assert @hans.friends_with?(@john)
    @john.destroy_relationship_with(@hans)
    assert_not @john.friends_with?(@hans)
    assert_not @hans.friends_with?(@john)
    assert_not @john.requestees.include?(@hans)
    assert_not @hans.requestors.include?(@john)
  end

  test 'determine the relationship with other user' do
    assert_equal @john.determine_relationship_with(@hans), 'stranger'
    assert_equal @hans.determine_relationship_with(@john), 'stranger'
    @john.send_friend_request_to(@hans)
    assert_equal @john.determine_relationship_with(@hans), 'requestee'
    assert_equal @hans.determine_relationship_with(@john), 'requestor'
    @hans.accept_friend_request(@john)
    assert_equal @john.determine_relationship_with(@hans), 'friends'
    assert_equal @hans.determine_relationship_with(@john), 'friends'
  end

  test 'finds the relationship with other user' do
    relationship = @john.send_friend_request_to(@hans)
    assert_equal @john.find_relationship_with(@hans), relationship
  end

  test 'associated posts should be destroyed' do
    @user.save
    @user.posts.create!(content: 'Lorem ipsum')
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  test 'associated reactions should be destroyed' do
    @user.save
    @user.reactions.create!(post_id: @jane_post.id)
    assert @user.reactions.count == 1
    assert_difference ['Reaction.count', '@jane_post.reactions.count'], -1 do
      @user.destroy
    end
  end

  test 'should like a post' do
    assert_difference '@jane_post.reactions.count', 1 do
      @john.likes(@jane_post)
    end
  end

  test 'should check if the user liked a post' do
    assert_not @john.likes?(@jane_post)
    @john.likes(@jane_post)
    assert @john.likes(@jane_post)
  end

  test 'should unlike a post' do
    @john.likes(@jane_post)
    assert @john.likes?(@jane_post)
    assert_difference ['Reaction.count', '@jane_post.reactions.count'], -1 do
      @john.unlikes(@jane_post)
    end
  end

  test 'associated comments should be destroyed' do
    @user.save
    @user.comments.create!(post_id: @jane_post.id, content: 'Lorem ipsum')
    assert @user.comments.count == 1
    assert_difference ['Comment.count', '@jane_post.comments.count'], -1 do
      @user.destroy
    end
  end

  test 'news feed should have the right post' do
    ruby = users(:ruby)
    barry = users(:barry)
    # Posts from a friend
    assert ruby.posts.count > 0
    ruby.posts.each do |post|
      assert @john.news_feed.include?(post)
    end
    # Posts from self
    assert @john.posts.count > 0
    @john.posts.each do |post|
      assert @john.news_feed.include?(post)
    end
    # Posts from stranger
    assert barry.posts.count > 0
    barry.posts.each do |post|
      assert_not @john.news_feed.include?(post)
    end
  end
end
