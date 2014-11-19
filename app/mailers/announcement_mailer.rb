# Tom Lai
class AnnouncementMailer < ActionMailer::Base
  add_template_helper UsersHelper
  default from: "noreply.housemates@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.invite_email.subject
  #

  def self.send_announcement_email(announcement)
     announcement.user.housemates.each do |recipient|
       announcement_email(announcement, recipient).deliver
     end
  end

  def announcement_email(announcement, recipient)
    @announcement = announcement
    mail to: recipient.email, subject: announcement.user.name+' has made an announcement!'
  end
end