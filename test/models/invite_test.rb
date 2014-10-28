# Tom Lai

require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  def setup
    @hh = Household.create(name: "Tom House")
    @i = Invite.create(household: @hh, email: "tom@tom.com")
    assert @i.save, @i.errors.first
    @u = User.new(name: "Example User",
                  email: "tom@tom.com",
                  password: "letmein",
                  password_confirmation: "letmein")
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
    assert_equal "tom@tom.com", @i.email
  end

  test "has many invites" do
    assert_equal @hh.invites.count, 1
    @hh2 = Household.create(name: "Andre House")
    @i2 = Invite.create(household: @hh2, email: "tom@tom.com")
    assert_equal 2, @u.invites.count
  end

  test "users cannot be invited twice by the same household" do
    assert_equal @hh.invites.count, 1
    @i2 = Invite.new(household: @hh, email: "tom@tom.com")
    assert_not @i2.valid?
  end
end
