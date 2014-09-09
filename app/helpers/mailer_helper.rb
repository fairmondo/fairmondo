module MailerHelper
  def inline_logos
    ['logo', 'logo_small', 'email_header'].each do |image|
      attachments.inline["#{image}.png"] = {
                                       data: File.read("#{Rails.root}/app/assets/images/email/#{image}.png"),
                                       mime_type: "image/png"
                                     }
    end
  end
end
