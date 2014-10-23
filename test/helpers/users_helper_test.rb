require 'test_helper'

class UsersHelperTest < ActionView::TestCase

  test "homepage_for without household" do
    user = users(:michael)
    user.household = nil
    user.save
    assert user.household.nil?
    assert_equal invites_path, homepage_for(user)
  end
end

