#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module MailerHelper
  def inline_logos
    %w(logo logo_small email_header cfk_abo_box).each do |image|
      attachments.inline["#{image}.png"] = {
        data: File.read("#{Rails.root}/app/assets/images/email/#{image}.png"),
        mime_type: 'image/png'
      }
    end
  end
end
