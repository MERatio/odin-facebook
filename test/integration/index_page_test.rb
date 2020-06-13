require 'test_helper'

class IndexPageTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    sign_in(@user)
  end

  test 'post form display' do
    get root_path
    assert_select 'form[action=?]', posts_path
  end

  test 'news feed display' do
    get root_path
    @user.news_feed.paginate(page: 1, per_page: 10).each do |post|
      assert_match post.author.full_name,        response.body
      assert_match format_date(post.created_at), response.body
      assert_match CGI.escapeHTML(post.content), response.body
      assert_match post.reactions.count.to_s,    response.body
      assert_match post.comments.count.to_s,     response.body
      # Post actions
      assert_select "div#like-or-unlike-#{post.id}"
      assert_select 'form[action=?]',            post_comments_path(post)
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
