# Tom Lai, Andre Haas

require 'test_helper'

class BalanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@u1 = User.create(name: "Example User1", email: "user1@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
  	@u2 = User.create(name: "Example User2", email: "user2@example.com",
                     password: "letmein", 
                     password_confirmation: "letmein")
    @b = Balance.create(user1: @u1, user2: @u2, amount: 10)
  end

 	test "balance foreign keys" do
 		assert @b.user1
 		assert @b.user2
 	end

  test "get balance amount" do
  	assert_equal 10, Balance.get(@u1, @u2)
  	assert_equal -10, Balance.get(@u2, @u1)
  end

  test "get balance object" do
  	assert_equal @b, Balance.get_balance(@u1, @u2)
  	assert_equal @b, Balance.get_balance(@u2, @u1)
  end

  test "users cannot be the same" do
  	@b2 = Balance.new(user1: @u1, user2: @u1, amount: 0)
  	assert_not @b2.save
  end

  test "balance can be saved" do
  	@b.amount += 1
  	assert @b.save
  	assert 11, @b.amount
  end

  test "duplicate balance should not be created" do
  	@b2 = Balance.new(user1: @u1, user2: @u2, amount: 0)
  	assert_not @b2.save
  end

  test "duplicate balance with reversed user1, user2 should not be created" do
  	@b2 = Balance.create(user1: @u2, user2: @u1, amount: 0)
  	assert_not @b2.save
  end


end
