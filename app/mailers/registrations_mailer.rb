#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RegistrationsMailer < ActionMailer::Base
  helper MailerHelper

  default from: EMAIL_ADDRESSES['default']

  def voluntary_contribution_email(email, amount)
    @amount = amount
    mail(to: email, subject: 'Dein freiwilliger Grundbeitrag für Fairmondo')
  end
end
