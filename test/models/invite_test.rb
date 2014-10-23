# Tom Lai

require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  def setup
    @hh = Household.create(name: "Tom House")
    @i = Invite.create(household: @hh, email: "tom@tom.com")
  end

  test "should be valid" do
    assert @i.valid?
  end

  test "household should be present" do
    @i.household = nil
    assert_not @i.valid?
  end

  test "household should exist in database" do
    @i.household = Household.new()
    assert_not @i.valid?
  end

  test "email should be present" do
    @i.email = nil
    assert_not @i.valid?
  end

  test "email should not be empty" do
    @i.email = ""
    assert_not @i.valid?

    @i.email = "   "
    assert_not @i.valid?
  end

  test "email should be valid" do
    @i.email = "hi"
    assert_not @i.valid?

    @i.email = "hi@blah"
    assert_not @i.valid?
  end

  test "email should be downcase after save" do
    @i.email = "TOM@TOM.COM"
    @i.save
    assert @i.email = "tom@tom.com"
  end
end
