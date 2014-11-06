# Tom Lai
# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/invite_mailer/invite_email
  def invite_email
    invite = Invite.new(email: 'to@example.org', id: 1)
    InviteMailer.invite_email(invite)
  end

end
