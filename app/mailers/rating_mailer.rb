#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RatingMailer < ActionMailer::Base
  default from: EMAIL_ADDRESSES['default']

  def bad_seller_notification user
    mail(to: EMAIL_ADDRESSES['default'], subject: "User #{user.id} wurde als schlechter Verkäufer eingestuft. Bitte überprüfen.")
  end
end
