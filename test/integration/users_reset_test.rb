# Opal Kale

require 'test_helper'

class UsersResetTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = User.create(name: "jackie", email: "jackie@example.com",
                      password: "letmein", 
                      password_confirmation: "letmein")
  end

  test "no email in database" do
    post_via_redirect reset_create_path, email: 'doesntexist@example.com'
    assert_template 'users/new'
  end

  test "successful password reset" do
    get forget_password_path
    post_via_redirect reset_create_path, email: @user1.email
    get reset_path
    @user1.reload
    post_via_redirect reset_path, email: @user1.email, password: @user1.password, token: @user1.reset_digest
    assert_template 'users/new'
    assert_not flash.empty?
  end

  test "unsuccessful password reset" do
    post_via_redirect reset_create_path, email: @user1.email
    get reset_path
    @user1.reload
    post_via_redirect reset_path, email: @user1.email, password: @user1.password, token: 'incorrect token'
    assert_template 'users/new'
    assert_not flash.empty?
  end

  test "forget password form" do
    get forget_password_path
    assert_template 'users/forget_password'
  end

end