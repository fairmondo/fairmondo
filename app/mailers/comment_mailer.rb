#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CommentMailer < ActionMailer::Base
  include MailerHelper
  before_action :inline_logos

  default from: EMAIL_ADDRESSES['default']
  layout 'email'

  def report_comment(comment, commentable_owner)
    @commentable = comment.commentable
    @commentable_owner = commentable_owner

    mail(to: @commentable_owner.email,
         subject: I18n.t('comment.mailer.notification_title'))
  end
end
