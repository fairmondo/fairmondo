#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class FeedbackMailer < ActionMailer::Base


  def feedback_and_help( feedback, topic )

    @text = feedback.text
    @type = feedback.type
    from = feedback.from? ? feedback.from : $email_addresses['ArticleMailer']['default_from']

    if $email_addresses
      mail(to: $email_addresses['FeedbackMailer'][@type][topic], from: from, subject: feedback.subject)
    end
  end

end
