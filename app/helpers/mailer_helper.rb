#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
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

  def voluntary_contribution_link(amount)
    case amount
    when 3
      'https://automatic.fastbill.com/purchase/7f1d4c9a3c8e6ec21543fde6377132d6/25-1'
    when 5
      'https://automatic.fastbill.com/purchase/7f1d4c9a3c8e6ec21543fde6377132d6/25-2'
    when 10
      'https://automatic.fastbill.com/purchase/7f1d4c9a3c8e6ec21543fde6377132d6/25-3'
    else
      ''
    end
  end
end
