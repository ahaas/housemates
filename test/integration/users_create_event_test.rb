# David Tien and Opal Kale

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

    log_in_as @user1, password: "daringdarius"
  end

  test "create event" do
    assert_select "span[class=fc-title]", count: 0
    post_via_redirect events_create_path, name: "valid event", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    assert_template "events/show"
    assert_not flash[:success].empty?
  end

  test "create event with empty name" do
    post_via_redirect events_create_path, name: "", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    assert_template "events/new"
  end

  test "create event with empty start" do
    post_via_redirect events_create_path, name: "no start", start_at: "", end_at: "11/7/2014 4:00 PM"
    assert_template "events/new"
  end

  test "create event with empty end" do
    post_via_redirect events_create_path, name: "no start", start_at: "11/7/2014 3:00 PM", end_at: ""
    assert_template "events/new"
  end

  test "renders new event page" do
    get events_new_path
    assert_template 'events/new'
  end

  test "edit unknown event" do
    # Creating a new event
    post_via_redirect events_create_path, name: "valid event", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    @event1 = Event.last()
    get events_edit_path, id: nil
    assert_template 'events/show'
    assert_not flash.empty?
  end

  test "renders edit event page" do
    # Creating a new event
    post_via_redirect events_create_path, name: "valid event", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    @event1 = Event.last()
    get events_edit_path, id: @event1.id
    assert_template 'events/edit', id: @event1.id 
  end

  test "successfully delete event" do
    # Creating a new event
    post_via_redirect events_create_path, name: "valid event", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    @event1 = Event.last()

    post_via_redirect events_update_path(id: @event1.id, commit: 'Delete event', name: @event1.name, start_at: @event1.start_at, end_at: @event1.end_at)
    assert_template 'events/show'
  end

  test "successfully update event" do
    # Creating a new event
    post_via_redirect events_create_path, name: "valid event", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    @event1 = Event.last()

    post_via_redirect events_update_path(id: @event1.id, commit: 'Save', name: "New event name", start_at: @event1.start_at, end_at: @event1.end_at)
    assert_template 'events/show'
    assert_not flash.empty?
  end

  test "unsuccessfully update event" do
    # Creating a new event
    post_via_redirect events_create_path, name: "valid event", start_at: "11/7/2014 3:00 PM", end_at: "11/7/2014 4:00 PM"
    @event1 = Event.last()

    post events_update_path(id: @event1.id, commit: 'Save', name: "New event name", start_at: "11/7/2014 4:00 PM", end_at: "11/7/2014 3:00 PM")
    assert_template 'events/edit'
    post_via_redirect events_update_path, id: nil
    assert_template 'events/show'
  end

end
