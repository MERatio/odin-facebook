require 'test_helper'

class PostShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @post = posts(:jane_post_1)
    sign_in(@user)
  end

  test 'post show display' do
    get post_path(@post)
    assert_template 'posts/show'
    assert_match @post.author.full_name,            response.body
    assert_match format_date(@post.created_at),     response.body
    assert_match CGI.escapeHTML(@post.content),     response.body
    assert_match @post.reactions.count.to_s,        response.body
    assert_match @post.comments.count.to_s,         response.body
    # Post actions
    assert_select "div#like-or-unlike-#{@post.id}"
    # Post comments
    @post.comments.paginate(page: 1).each do |comment|
      assert_match comment.user.full_name,          response.body
      assert_match comment.content,                 response.body
      assert_match format_date(comment.created_at), response.body
    end
    assert_select 'div.pagination'
  end
end
