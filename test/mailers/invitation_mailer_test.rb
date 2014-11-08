# Tom Lai and Andre Haas
require 'test_helper'

class InviteMailerTest < ActionMailer::TestCase
  test "invitation_email" do
    inviter = User.new(name: 'Michael')
    invitee = 'to@example.org'
    invite = Invite.new(email: invitee, id: 1)
    mail = InviteMailer.invite_email(invite, inviter)

    assert_equal "Welcome to Housemates!", mail.subject
    assert_equal [invitee], mail.to
    assert_match inviter.name, mail.body.encoded
    assert_equal ["noreply.housemates@gmail.com"], mail.from
    assert_match 'Welcome to Housemates!',  mail.body.encoded
    assert_match 'invites you to use Housemates!',
    mail.body.encoded
    assert_match 'To login to the site, just click',
        mail.body.encoded
    assert_match 'Thanks for joining Housemates and have a great day!', 
    mail.body.encoded
    assert_match 'email=to%40example.org',  mail.body.encoded
  end

end
