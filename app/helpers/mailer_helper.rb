module MailerHelper
  def inline_logos
    attachments.inline['logo.png'] = {
                                       data: File.read("#{Rails.root}/app/assets/images/email/logo.png"),
                                       mime_type: "image/png"
                                     }
    attachments.inline['logo_small.png'] = {
                                             data: File.read("#{Rails.root}/app/assets/images/email/logo_small.png"),
                                             mime_type: "image/png"
                                           }
  end
end
