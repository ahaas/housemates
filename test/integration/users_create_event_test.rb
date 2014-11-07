# David Tien

require 'test_helper'

class UsersCreateEventTest < ActionDispatch::IntegrationTest
  def setup
     # User without a household
    @user1 = User.create(name: "Darius", email: "darius@example.com",
                     password: "daringdarius", 
                     password_confirmation: "daringdarius")
    @household1 = Household.create(name: 'Eventful')
    @user1.household = @household1
    @user1.save
  end

  test "create event" do
    log_in_as @user1, password: "daringdarius"
    assert_select "span[class=fc-title]", count: 0
    post_via_redirect events_create_path, name: "valid event", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    assert_template "events/show"
    assert_not flash[:success].empty?
  end

  test "create event with empty name" do
    log_in_as @user1, password: "daringdarius"
    assert_select "span[class=fc-title]", count: 0
    post_via_redirect events_create_path, name: "", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    assert_template "events/new"
  end

  test "create event with empty start" do
    log_in_as @user1, password: "daringdarius"
    assert_select "span[class=fc-title]", count: 0
    post_via_redirect events_create_path, name: "no start", start_at: "", end_at: "11/7/2014 4:00 PM"
    assert_template "events/new"
  end

  test "create event with empty end" do
    log_in_as @user1, password: "daringdarius"
    assert_select "span[class=fc-title]", count: 0
    post_via_redirect events_create_path, name: "no start", start_at: "11/7/2014 3:00 PM", end_at: ""
    assert_template "events/new"
  end
end
