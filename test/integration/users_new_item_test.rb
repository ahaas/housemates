# Opal Kale
require 'test_helper'

class UsersNewItemTest < ActionDispatch::IntegrationTest
  def setup
    # Creates User #1 & User #2
    @user1 = User.create(name:  "opal", email: "opal@example.com",
                      password: "letmein", 
                      password_confirmation: "letmein")
    @user2 = User.create(name: "eric", email: "eric@example.com",
                     password: "letmein", 
                      password_confirmation: "letmein")

    # Creates 'Stars' Household
    @household1 = Household.create(name: 'stars')

    # Adds User #1 & User #2 to 'Stars' Household
    @user1.household = @household1
    @user1.save

    @user2.household = @household1
    @user2.save

    @user1_id = @user1.id
    @user2_id = @user2.id
    # Creates balance for each user
    Balance.create(user1: @user1, user2: @user2)

    # Logs User #1 in
    log_in_as @user1, password: "letmein"
  end

  test "add new item button" do
    get transactions_new_item_path
    assert_template 'transactions/new_item'
  end

  test "num of rows generated = 3 before any transactions" do
    get transactions_show_path
    assert_select "tr", count: 3 # Rows for Balance Titles, Rows for 1 Housemate, and row for Transaction Titles.
  end
  
  test "add new item" do
    post_via_redirect transactions_create_path, name: 'detergent', amount: '10.0', commit: 'Add item', payers: [@user1_id, @user2_id]
    assert_template 'transactions/show'
    assert_select "tr", count: 4 # Additonal row generated for new transaction
  end
    
  test "invalid name flash message" do
    #debugger
    post_via_redirect transactions_create_path, name: nil, amount: '0.0', commit: 'Add item', payers: [@user1_id, @user2_id]
    assert_template 'transactions/show'
    assert_not flash.empty?
  end

  test "invalid amount flash message" do
    post_via_redirect transactions_create_path, name: 'detergent', amount: '0.0', commit: 'Add item', payers: [@user1_id, @user2_id]
    assert_template 'transactions/show'
    assert_not flash.empty?
  end

end