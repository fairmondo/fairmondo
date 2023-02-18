#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserMailer < ActionMailer::Base
  include MailerHelper

  default from: EMAIL_ADDRESSES['default']
  before_action :inline_logos
  layout 'email'

  def contact(sender:, resource_id:, text:)
    @sender   = sender
    @receiver = User.find resource_id
    @text     = text
    @subject  = I18n.t('email.user.contact.subject', sender_name: @sender.name)
    mail to: @receiver.email, subject: @subject, reply_to: @sender.email
  end
end
