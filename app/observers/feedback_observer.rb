#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FeedbackObserver < ActiveRecord::Observer
  def after_save(feedback)
    # Send the feedback
    case feedback.variety
    when 'report_article' then
      ArticleMailer.report_article(feedback.article,
                                   feedback.user,
                                   feedback.text).deliver_later
    when 'send_feedback' then
      feedback.subject.prepend('[Feedback] ')
      FeedbackMailer
        .feedback_and_help(feedback, feedback.feedback_subject)
        .deliver_later
    when 'get_help' then
      feedback.subject.prepend('[Hilfe] ')
      FeedbackMailer
        .feedback_and_help(feedback, feedback.help_subject)
        .deliver_later
    when 'become_donation_partner' then
      # FeedbackMailer.donation_partner(feedback).deliver_later
    end
  end
end
