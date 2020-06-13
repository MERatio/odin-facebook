require 'test_helper'

class PostsReactionsShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @post = posts(:jane_post_1)
    sign_in(@user)
  end

  test 'post reactions display' do
    get post_reactions_path(@post)
    assert_template 'reactions/index'
    assert_match @post.reactions.count.to_s, response.body
    @post.reactions.paginate(page: 1).each do |reaction|
      assert_select 'img[alt=?]',           reaction.user.full_name
      assert_match reaction.user.full_name, response.body
    end
    assert_select 'div.pagination'
  end
end
