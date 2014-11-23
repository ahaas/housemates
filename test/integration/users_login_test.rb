# Opal Kale
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  include UsersHelper

  def setup
    @user = users(:michael)
    # User without a household
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "redirect to homepage if logged in" do
    @user1 = User.create(name: "jackie", email: "jackie@example.com",
                    password: "letmein", 
                    password_confirmation: "letmein")
    log_in_as @user1, password: 'letmein'

    @household1 = Household.create(name: 'stars')
    @user1.household = @household1
    @user1.save

    get login_path
    follow_redirect!
    assert_template 'households/show'
  end

  test "login required to access homepage" do
    get home_path
    assert_not flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to invites_path
    follow_redirect!
    assert_template 'invites/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path

    get root_path
    assert_template 'invites/show'

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'users/new'
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", logout_path, count: 0
  end
end
