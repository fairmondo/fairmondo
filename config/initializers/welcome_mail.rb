#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Devise::Models::Confirmable

  # Override Devise's own method. This one is called only on user creation, not on subsequent address modifications.
  def send_on_create_confirmation_instructions
    DeviseMailer.welcome_mail(self).deliver
  end

    # Send confirmation instructions by email
    def send_confirmation_instructions

      resend = !self.confirmation_token.blank?

      self.confirmation_token = nil if reconfirmation_required?
      @reconfirmation_required = false

      generate_confirmation_token! if self.confirmation_token.blank?

      opts = pending_reconfirmation? ? { :to => unconfirmed_email } : { }

      if resend
        DeviseMailer.welcome_mail(self).deliver
      else
        send_devise_notification(:confirmation_instructions, opts)
      end

    end

end