require 'test_helper'

class AnnouncementMailerTest < ActionMailer::TestCase
  
  test "invitation_email" do
    recipient = User.new(name: 'Michael', email:'michael@housemates.com')
    announcement = Announcement.new(
      user: recipient, 
      text:'secret message in the announcement')
    mail = AnnouncementMailer.announcement_email(announcement, recipient)

    assert_equal recipient.name + " has made an announcement!", mail.subject
    assert_equal [recipient.email], mail.to
    assert_match recipient.name, mail.body.encoded
    assert_equal ["noreply.housemates@gmail.com"], mail.from
    assert_match 'has made an announcement!',  mail.body.encoded
    assert_match 'Thanks for joining', mail.body.encoded
    assert_match 'Housemates', mail.body.encoded
    assert_match 'and have a great day!', mail.body.encoded
  end
end
