# Tom Lai

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

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

  test "housemates method with no housemates" do
    @hh = Household.create(name:"hh")
    @user.household = @hh
    @user.save
    assert_equal 0, @user.housemates.count
  end

  test "housemates method with some housemates" do
    @hh = Household.create(name:"hh")
    @user.household = @hh
    @u0 = @user
    @u0.save
    @u1 = User.create(name: "u1", email: "u1@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein",
                     household: @hh)
    @u2 = User.create(name: "u2", email: "u2@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein",
                     household: @hh)
    assert_equal 2, @u0.housemates.count
    assert_equal 2, @u1.housemates.count
    assert_equal 2, @u2.housemates.count
    assert_not @u0.housemates.include? @u0
    assert @u0.housemates.include? @u1
    assert @u0.housemates.include? @u2
    assert @u1.housemates.include? @u0
    assert_not @u1.housemates.include? @u1
    assert @u1.housemates.include? @u2
    assert @u2.housemates.include? @u0
    assert @u2.housemates.include? @u1
    assert_not @u2.housemates.include? @u2
  end

  test "password reset with valid and correct entries" do
    user = User.create(name: 'User', email:'user@housemates.com',
      password: '000000', password_confirmation: '000000')
    user.create_reset_digest
    user.reload
    new_password = 'password'
    result = user.reset_password(user.reset_digest, new_password, new_password)
    assert_equal 0, result
  end

  test "password reset with bad password entries" do
    user = User.create(name: 'User', email:'user@housemates.com',
      password: '000000', password_confirmation: '000000')
    user.create_reset_digest
    user.reload
    new_password = 'pass'
    result = user.reset_password(user.reset_digest, new_password, new_password)
    assert_equal -1, result
  end

  test "password reset with bad token" do
    user = User.create(name: 'User', email:'user@housemates.com',
      password: '000000', password_confirmation: '000000')
    user.create_reset_digest
    user.reload
    new_password = 'password'
    result = user.reset_password('very bad token', new_password, new_password)
    assert_equal -1, result
  end

  test 'transactions_with_user method with valid inputs' do
    @hh = Household.create(name:"hh")
    @user.household = @hh
    @user.save
    @user1 = @user
    @user2 = User.create(name: "Example User", email: "user2@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein",
                     household: @hh)
    @tg = TransactionGroup.create(name: "test transaction", 
      total_amount: 10.0)
    @t1 = Transaction.create(payer:@user1, payee:@user2, household: @hh, 
      transaction_group: @tg, is_payback: false, amount: 5.00)
    @t2 = Transaction.create(payer:@user2, payee:@user1, household: @hh, 
      transaction_group: @tg, is_payback: false, amount: 5.00)
    assert_equal 2, @user1.transactions_with_user(@user2).length,
      'user 1 transactions with user 2 does not contain all transactions'
    assert_equal 2, @user2.transactions_with_user(@user1).length
      'user 2 transactions with user 1 does not contain all transactions'
    assert @user1.transactions_with_user(@user2).include?(@t1), 
      'user 1 transactions with user 2 contains transaction 1'
    assert @user1.transactions_with_user(@user2).include?(@t2), 
      'user 1 transactions with user 2 contains transaction 2'
    assert @user2.transactions_with_user(@user1).include?(@t1), 
      'user 2 transactions with user 1 contains transaction 1'
    assert @user2.transactions_with_user(@user1).include?(@t2), 
      'user 2 transactions with user 1 contains transaction 2'
  end
end
