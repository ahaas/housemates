# Opal Kale

require 'test_helper'

class UsersResetTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = User.create(name: "jackie", email: "jackie@example.com",
                      password: "letmein", 
                      password_confirmation: "letmein")
  end

  test "it creates a reset for a user with an email" do
    post_via_redirect reset_create_path, email: @user1.email
    assert_template 'users/new'
  end

  test "reset password" do
    get reset_path
    assert_template 'users/reset'
    post_via_redirect reset_path email: 'jackie@example.com', token: '123', password: 'password', password_confirmation: 'password'
    assert_template 'users/new'
    assert_not flash.empty?
  end

end