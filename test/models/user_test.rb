require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: 'Example', last_name: 'User', 
                     email: 'user@example.com', password: 'foobar',
                     password_confirmation: 'foobar')
    @john = users(:john)
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
end
