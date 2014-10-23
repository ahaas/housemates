# Tom Lai

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  def setup
    @u1 = User.create(name: "tom", email: "tom@example.com", 
      password: "letmein", password_confirmation: "letmein")
    @u2 = User.create(name: "andre", email: "andre@example.com", 
      password: "letmein", password_confirmation: "letmein")
    @tg = TransactionGroup.create(name: "test transaction", 
      total_amount: 10.0)
    @hh = Household.create(name: "Tom House")
    @t = Transaction.create(payer:@u1, payee:@u2, household: @hh, 
      transaction_group: @tg, is_payback: false, amount: 1.00)
    @t1 = Transaction.create(payer:@u1, payee:@u2, household: @hh, 
      transaction_group: @tg, is_payback: false, amount: 1.00)
  end

  test "should be valid" do
    assert @t.valid?
  end

  test "reverse lookup on payer" do
    assert_equal 2, @u1.transactions_as_payer.count
  end

  test "reverse lookup on payee" do
    assert_equal 2, @u2.transactions_as_payee.count
  end  

  test "payer should be present" do
    @t.payer = nil
    assert_not @t.valid?
  end

  test "payer should exist in database" do
    @t.payer = User.new()
    assert_not @t.valid?
  end

  test "payee should be present" do
    @t.payee = nil
    assert_not @t.valid?
  end

  test "payee should exist in database" do
    @t.payee = User.new()
    assert_not @t.valid?
  end

  test "household should be present" do
    @t.household = nil
    assert_not @t.valid?
  end

  test "household should exist in database" do
    @t.household = Household.new()
    assert_not @t.valid?
  end

  test "transaction_group should be present" do
    @t.transaction_group = nil
    assert_not @t.valid?
  end

  test "transaction_group should exist in database" do
    @t.transaction_group = TransactionGroup.new()
    assert_not @t.valid?
  end

  test "is_payback should be present" do
    @t.is_payback = nil
    assert_not @t.valid?
  end

  test "amount should be present" do
    @t.amount = nil
    assert_not @t.valid?
  end

  test "negative amount should not be valid" do
    @t.amount = -1.0
    assert_not @t.valid?
  end

  test "zero amount should not be valid" do
    @t.amount = 0.0
    assert_not @t.valid?
  end

  test "amount should round off after save" do
    @t.amount = 1.5454
    @t.save
    assert @t.amount = 1.55

    @t.amount = 1.5444
    @t.save
    assert @t.amount = 1.54
  end
end
