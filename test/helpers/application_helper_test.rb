class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title,            'Odin Facebook'
    assert_equal full_title('Sign up'), 'Sign up | Odin Facebook'
  end
end
