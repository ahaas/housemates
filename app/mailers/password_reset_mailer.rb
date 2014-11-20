# Tom Lai
class PasswordResetMailer < ActionMailer::Base
  default from: "noreply.housemates@gmail.com"

  def password_reset_email(user)
    @user = user
    @token = @user.reset_digest
    @url = reset_url(email: @user.email, token: @token)
    mail to: user.email, subject: 'Password reset'
  end
end
