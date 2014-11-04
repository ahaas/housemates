# Tom Lai

require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase

  def setup
    @u = User.create(name: 'Example User1', email: 'user1@example.com',
                     password: 'letmein', 
                     password_confirmation: 'letmein')
    @hh = Household.create(name: 'Test household')
    @t = 'text'
    @a = Announcement.new(user: @u, text: @t, household: @hh)
  end

  test 'should be valid' do
    assert @a.valid?
  end

  test 'user should be present' do
    @a.user = nil
    assert_not @a.valid?
  end

  test 'user should exist in database' do
    assert @a.valid?
    @a.user = User.new()
    assert_not @a.valid?
  end

  test 'household should be present' do
    @a.household = nil
    assert_not @a.valid?
  end

  test 'household should exist in database' do
    assert @a.valid?
    @a.household = Household.new()
    assert_not @a.valid?
  end

  test 'text should be present' do
    @a.text = nil
    assert_not @a.valid?
  end

  test 'text should not be empty' do
    @a.text = ''
    assert_not @a.valid?
  end

  test 'text should not contain spaces only' do
    @a.text = '   '
    assert_not @a.valid?
  end

  test 'announcement should be able to be reversely looked up' do
    @a.save
    assert @hh.announcements.include? @a
    @a2 = Announcement.create(user: @u, text: 'announcement 2', household: @hh)
    assert @hh.announcements.include? @a
    assert @hh.announcements.include? @a2
    @a3 = Announcement.create(user: @u, text: 'announcement 3', household: @hh)
    assert @hh.announcements.include? @a
    assert @hh.announcements.include? @a2
    assert @hh.announcements.include? @a3
  end

end
