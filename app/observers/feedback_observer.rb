# See http://rails-bestpractices.com/posts/19-use-observer
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

class FeedbackObserver < ActiveRecord::Observer

  def after_save(feedback)
    # Send the feedback
    case feedback.variety
      when "report_article" then
        ArticleMailer.delay.report_article(feedback.article,
                                           feedback.user,
                                           feedback.text)
      when "send_feedback" then
        feedback.subject.prepend("[Feedback] ")
        FeedbackMailer.delay.feedback_and_help(feedback,
                                               feedback.feedback_subject)
      when "get_help" then
        feedback.subject.prepend("[Hilfe] ")
        FeedbackMailer.delay.feedback_and_help(feedback, feedback.help_subject)
      when "become_donation_partner" then
        #FeedbackMailer.donation_partner(feedback).deliver
    end

  end

end
