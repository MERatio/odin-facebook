require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other_user = users(:jane)
    sign_in(@user)
  end
  
  test 'own profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.first_name)
    assert_match @user.full_name, response.body
    assert_select 'a[href=?]', edit_user_registration_path(@user), 
      text: 'Edit information', count: 1
    assert_select "div#friend-form-#{@user.id}", count: 0
    assert_match @user.friends.count.to_s, response.body
    assert_select 'a[href=?]', friends_user_path(@user), count: 1
    # Post form
    assert_select 'section.post-form', count: 1
    # Post count
    assert_match @user.posts.count.to_s, response.body
    # Posts
    @user.posts.paginate(page: 1, per_page: 10).each do |post|
      assert_match post.author.full_name,        response.body
      assert_match format_date(post.created_at), response.body
      assert_match CGI.escapeHTML(post.content), response.body
      assert_match post.reactions.count.to_s,    response.body
      assert_match post.comments.count.to_s,     response.body
      # Post actions
      assert_select "div#like-or-unlike-#{post.id}"
      # Post comments
      post.comments.take(3).each do |comment|
        assert_match comment.user.full_name,          response.body
        assert_match CGI.escapeHTML(comment.content), response.body
        assert_match format_date(comment.created_at), response.body
      end
    end
    assert_select 'div.pagination'
  end

  test 'other profile display' do
    get user_path(@other_user)
    assert_template 'users/show'
    assert_select 'title', full_title(@other_user.first_name)
    assert_match @other_user.full_name, response.body
    assert_select 'a[href=?]', edit_user_registration_path(@other_user), 
      text: 'Edit information', count: 0
    assert_select "div#friend-form-#{@other_user.id}", count: 1
    assert_match @other_user.friends.count.to_s, response.body
    assert_select 'a[href=?]', friends_user_path(@other_user), count: 1
    # Post form
    assert_select 'section.post-form', count: 0
    # Post count
    assert_match @other_user.posts.count.to_s, response.body
    # Posts
    @other_user.posts.paginate(page: 1, per_page: 10).each do |post|
      assert_match post.author.full_name,        response.body
      assert_match format_date(post.created_at), response.body
      assert_match CGI.escapeHTML(post.content), response.body
      assert_match post.reactions.count.to_s,    response.body
      assert_match post.comments.count.to_s,     response.body
      # Post actions
      assert_select "div#like-or-unlike-#{post.id}"
      # Post comments
      post.comments.take(3).each do |comment|
        assert_match comment.user.full_name,          response.body
        assert_match CGI.escapeHTML(comment.content), response.body
        assert_match format_date(comment.created_at), response.body
      end
    end
    assert_select 'div.pagination'
  end
end
