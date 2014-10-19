require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 129
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    # from www.railstutorial.org
    valid_addresses = %w[user@example.com USER@foo.COM 
                         A_US-ER@foo.bar.org first.last@foo.jp
                         alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid? "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    # from www.railstutorial.org
    invalid_addresses = %w[user@example,com user_at_foo.org
                           user.name@example. oo@bar_baz.com
                           foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, 
                 "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    # from www.railstutorial.org
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcased after save" do
    @user.email = "User@Example.com"
    @user.save
    assert_equal "user@example.com", @user.email
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
