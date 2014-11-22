# Opal Kale
require 'test_helper'

class UsersAnnouncementsTest < ActionDispatch::IntegrationTest
  
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

  test "show announcements" do
    get announcements_show_path
    assert_template 'announcements/show'
  end

  test "no announcements" do
    get announcements_show_path
    assert_select "div.announcement-text", count: 0
  end

  test "successfully update announcement" do
    # Creating a new announcement to update
    post_via_redirect announcements_create_path, commit: 'Post', text: 'Test announcement!'
    post_via_redirect announcements_update_path, announcement_id: Announcement.last.id, announcement_text: 'Updated announcement'
    assert_not flash.empty?
    assert_template 'announcements/show'
  end

  test "new announcement" do
    post_via_redirect announcements_create_path, commit: 'Post', text: 'Test announcement!'
    assert_template 'announcements/show'
    assert_select "div.announcement-text", text: 'Test announcement!'
  end

  test "empty announcement" do
    post_via_redirect announcements_create_path, commit: 'Post'
    assert_template 'announcements/show'
    assert_select "div.announcement-text", count: 0
  end

  test "delete announcement" do
    # Creating a new announcement to delete
    post_via_redirect announcements_create_path, commit: 'Post', text: 'Test announcement!', id: '1'
    assert_select "div.announcement-text", text: 'Test announcement!'
    # Deleting that announcement
    @announcement_id = Announcement.last.id
    delete_via_redirect announcements_destroy_path, id: @announcement_id
    assert_template 'announcements/show'
  end

end
