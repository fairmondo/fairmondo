#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class ArticleMailer < ActionMailer::Base
  include MailerHelper

  default from: $email_addresses['default']
  before_filter :inline_logos, except: :report_article
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
    terms_pdf
    mail(to: @user.email, subject: "[Fairmondo] Du hast einen Artikel auf Fairmondo eingestellt")
  end

  def mass_upload_activation_message mass_upload_id
    @mass_upload = MassUpload.find mass_upload_id
    @user = @mass_upload.user
    terms_pdf
    mail(to: @user.email, subject: "[Fairmondo] Du hast Deine per CSV-Dateien eingestellten Artikel aktiviert")
  end

  def mass_upload_failed_message mass_upload_id
    @mass_upload = MassUpload.find mass_upload_id
    @user = @mass_upload.user
    mail(to: @user.email, subject: "[Fairmondo] Bei deinem CSV-Upload sind Fehler aufgetreten")
  end

  def mass_upload_finished_message mass_upload_id
    @mass_upload = MassUpload.find mass_upload_id
    @user = @mass_upload.user
    subject = "[Fairmondo] Dein CSV-Upload ist abgeschlossen"
    if @mass_upload.articles_for_mass_activation.any?
      subject << ". Es liegen Artikel zur Aktivierung bereit!"
      @created_count = @mass_upload.created_articles.count
      @updated_count = @mass_upload.updated_articles.count
      @activated_count = @mass_upload.activated_articles.count
    end
    @deleted_count = @mass_upload.deleted_articles.count
    @deactivated_count = @mass_upload.deactivated_articles.count
    mail(to: @user.email, subject: subject)
  end

  private

    # attaches terms pdf to emails
    def terms_pdf
      attachments['AGB.pdf'] = File.read(Rails.root.join('app/assets/docs/AGB.pdf'))
    end
end
