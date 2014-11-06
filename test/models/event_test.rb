# Andre Haas

require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @hh = Household.create(name: "Tom House")
    @u = User.create(name: "Example User",
                  email: "tom@tom.com",
                  password: "letmein",
                  password_confirmation: "letmein",
                  household: @hh)
    @e = Event.create(name: "Party",
                      household: @hh,
                      user: @u,
                      start_at: DateTime.now,
                      end_at: DateTime.now + 1.hour)
  end

  test "foreign keys" do
    assert @hh.events.include? @e
    assert @u.events.include? @e
    assert_equal @hh, @e.household
    assert_equal @u, @e.user
  end

  test "end_at must be after start_at" do
    @e.end_at = DateTime.now - 1.hour
    assert_not @e.valid?
  end
end
