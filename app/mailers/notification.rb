#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Notification < ActionMailer::Base

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification.invitation.subject
  #
  #def invitation(id, user, name, email, activation_key)
  #
  #  key = SecureRandom.hex(24)
  #  @user = user
  #  @name = name
  #  @url  = "http://beta.fairnopoly.de/confirm_invitation?id=" + id.to_s + "&key=" + activation_key
  #
  #  mail(:to => email, :subject => ("Einladung auf Fairnopoly von "+@user.name) )
  #
  #end

end
