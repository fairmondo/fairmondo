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
  include MailerHelper

  default from: $email_addresses['default']
  before_filter :inline_logos, except: :report_article
  before_filter :inline_terms_pdf, only: [:article_activation_message, :mass_upload_activation_message]
  layout 'email', except: :report_article


  def report_article article, user, text
    @text = text
    @article = article
    @user = user
    mail = @user ? @user.email : $email_addresses['default']
    mail(to: $email_addresses['ArticleMailer']['report'], from: mail, subject: "Article reported with ID: #{article.id}")
  end

  def contact from, to, text, article
    @text = text
    @article = article
    @from = from
    mail to: to, subject: I18n.t('article.show.contact.mail_subject')
  end

  def article_activation_message article_id
    @article = Article.find article_id
    @user    = @article.user

    mail(to: @user.email, subject: "[Fairnopoly] Du hast einen Artikel auf Fairnopoly eingestellt")
  end

  def mass_upload_activation_message mass_upload_id
    @mass_upload = MassUpload.find mass_upload_id
    @user = @mass_upload.user

    mail(to: @user.email, subject: "[Fairnopoly] Du hast Deine per CSV-Datein eingestellten Artikel eingestellt")
  end

  private

    # attaches terms pdf to emails
    def inline_terms_pdf
      attachments['AGB.pdf'] = {
        data: File.read(Rails.root.join('app/assets/docs/AGB_Fairnopoly_FINAL.pdf')),
        mime_type: 'application/pdf'
      }
    end
end
