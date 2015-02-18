class UserMailer < ActionMailer::Base
  include MailerHelper

  default from: $email_addresses['default']
  before_filter :inline_logos
  layout 'email'

  def contact(sender:, resource_id:, text:)
    @sender   = sender
    @receiver = User.find resource_id
    @text     = text
    @subject  = I18n.t('email.user.contact.subject')
    mail to: @receiver.email, subject: @subject
  end

end
