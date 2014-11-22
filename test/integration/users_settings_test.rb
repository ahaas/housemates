# Opal Kale

require 'test_helper'

class UsersSettingsTest < ActionDispatch::IntegrationTest
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

      # Logs User #1 in
      log_in_as @user1, password: "letmein"
    end

  test "show settings" do
    get settings_show_path
    assert_template 'settings/show'
  end

  test "update household" do
    post_via_redirect households_update_path, commit: 'Update', household: {name: 'Updated Name'}
    assert_template 'settings/show'
  end

  test "update household without an invalid name" do
    post_via_redirect households_update_path, commit: 'Update', household: {name: ''}
    assert_not flash.empty?
  end

  test "leave household" do
    post_via_redirect households_leave_path, commit: "Leave household"
    assert_template 'invites/show'
  end

end