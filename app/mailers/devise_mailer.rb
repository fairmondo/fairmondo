#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class DeviseMailer < Devise::Mailer
  # helper :application # gives access to all helpers defined within `application_helper`.
  include MailerHelper
  before_filter :inline_logos
  layout 'email'

  def welcome_mail(record, token, _opts = {})
    attachments['AGB_Fairmondo.pdf'] = File.read(Rails.root.join('app/assets/docs/AGB.pdf'))
    attachments['Datenschutz_Fairmondo.pdf'] = File.read(Rails.root.join('app/assets/docs/Datenschutz_Fairmondo_FINAL.pdf'))

    @token = token
    devise_mail(record, :welcome_mail)
  end

  def confirmation_instructions(record, token, opts = {})
    attachments['AGB_Fairmondo.pdf'] = File.read(Rails.root.join('app/assets/docs/AGB.pdf'))
    attachments['Datenschutz_Fairmondo.pdf'] = File.read(Rails.root.join('app/assets/docs/Datenschutz_Fairmondo_FINAL.pdf'))

    super
  end
end
