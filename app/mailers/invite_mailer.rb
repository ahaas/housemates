# Tom Lai
class InviteMailer < ActionMailer::Base
  default from: "noreply.housemates@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.invite_email.subject
  #
  def invite_email(invite, inviter)
    @inviter = inviter
    @url = signup_url(email: invite.email)
    mail to: invite.email, subject: 'Welcome to Housemates!'
  end
end
