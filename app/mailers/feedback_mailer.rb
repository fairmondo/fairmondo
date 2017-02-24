#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FeedbackMailer < ActionMailer::Base
  def feedback_and_help(feedback, topic)
    @feedback = feedback
    @feedback_subject = @feedback.translate_subject
    @last_article_id = @feedback.last_article_id
    from = feedback.from? ? feedback.from : EMAIL_ADDRESSES['default']

    attachments[feedback.image.image_file_name] = File.read(Rails.root.join(feedback.image.image.path(:original))) if feedback.image

    if EMAIL_ADDRESSES
      mail(to: EMAIL_ADDRESSES['FeedbackMailer'][@feedback.variety][topic], from: from, subject: @feedback.subject)
    end
  end

  def donation_partner(feedback)
    @feedback = feedback
    @last_article_id = @feedback.last_article_id
    if EMAIL_ADDRESSES
      mail(to: EMAIL_ADDRESSES['FeedbackMailer'][@feedback.variety], from: @feedback.from, subject: 'Spendenpartner*in Anfrage')
    end
  end
end
