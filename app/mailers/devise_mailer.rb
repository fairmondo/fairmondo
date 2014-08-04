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
class DeviseMailer < Devise::Mailer
  #helper :application # gives access to all helpers defined within `application_helper`.


  def welcome_mail(record, token, opts={})

    attachments['AGB_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/AGB_Fairnopoly_FINAL.pdf'))
    attachments['Datenschutz_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Datenschutz_Fairnopoly_FINAL.pdf'))
    attachments['Widerrufsformular_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Widerrufsformular.pdf'))

    @token = token
    devise_mail(record, :welcome_mail)

  end

  def confirmation_instructions(record, token, opts={})

    attachments['AGB_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/AGB_Fairnopoly_FINAL.pdf'))
    attachments['Datenschutz_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Datenschutz_Fairnopoly_FINAL.pdf'))
    attachments['Widerrufsformular_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Widerrufsformular.pdf'))

    super
  end

end
