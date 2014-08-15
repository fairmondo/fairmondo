#
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
class ArticleMailer < ActionMailer::Base
  default from: $email_addresses['default']

  def report_article article, user, text
    @text = text
    @article = article
    @user = user
    mail = @user ? @user.email : $email_addresses['default']
    mail(to: $email_addresses['ArticleMailer']['report'], from: mail, subject: "Article reported with ID: #{article.id}")
  end

  def category_proposal category_proposal
    mail(to: $email_addresses['ArticleMailer']['category_proposal'], subject: "Category proposal: #{category_proposal}")
  end

  def contact from, to, text, article
    @text = text
    @article = article
    @from = from
    mail to: to, subject: I18n.t('article.show.contact.mail_subject')
  end
end
