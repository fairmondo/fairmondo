#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module Devise::Models::Confirmable

  # Override Devise's own method. This one is called only on user creation, not on subsequent address modifications.
  def send_on_create_confirmation_instructions
    DeviseMailer.delay.welcome_mail(self, @raw_confirmation_token)
  end
end
