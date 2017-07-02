#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FeedbackRefinery < ApplicationRefinery
  def create
    [
      :from, :subject, :text, :variety, :article_id, :feedback_subject,
      :help_subject, :forename, :lastname, :organisation, :phone, :recaptcha
    ]
  end
end
