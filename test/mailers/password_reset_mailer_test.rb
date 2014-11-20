# Tom Lai
require 'test_helper'

class PasswordResetMailerTest < ActionMailer::TestCase
    test "password_reset_email" do
    user = User.new(
      name: 'Michael', 
      email: 'michael@housemates.com', 
      reset_digest: User.new_token)
    mail = PasswordResetMailer.password_reset_email(user)

    assert_equal 'Password reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply.housemates@gmail.com"], mail.from
    assert_match 'Hi '+user.name+',',  mail.body.encoded
    assert_match 'to reset your password!', mail.body.encoded
    assert_match ' and have a great day!', mail.body.encoded
  end
end
