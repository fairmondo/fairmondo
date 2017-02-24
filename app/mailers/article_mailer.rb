#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleMailer < ActionMailer::Base
  include MailerHelper

  default from: EMAIL_ADDRESSES['default']
  before_filter :inline_logos, except: :report_article
  layout 'email', except: :report_article

  def report_article article, user, text
    @text = text
    @article = article
    @user = user
    mail = @user ? @user.email : EMAIL_ADDRESSES['default']
    mail(to: EMAIL_ADDRESSES['ArticleMailer']['report'], from: mail, subject: "Article reported with ID: #{article.id}")
  end

  def contact(sender:, resource_id:, text:)
    @user     = sender
    @text     = text
    @article  = Article.find(resource_id)
    @from     = @user.email
    @subject  = I18n.t('article.show.contact.mail_subject')
    mail to: @article.seller_email, from: @from, subject: @subject
  end

  def article_activation_message article_id
    @article = Article.find article_id
    @article.calculate_fees_and_donations # just to be save
    @user    = @article.user
    terms_pdf
    mail(to: @user.email, subject: '[Fairmondo] Du hast einen Artikel auf Fairmondo eingestellt')
  end

  def mass_upload_activation_message mass_upload_id
    @mass_upload = MassUpload.find mass_upload_id
    @user = @mass_upload.user
    terms_pdf
    mail(to: @user.email, subject: '[Fairmondo] Du hast Deine per CSV-Dateien eingestellten Artikel aktiviert')
  end

  def mass_upload_failed_message mass_upload_id
    @mass_upload = MassUpload.find mass_upload_id
    @user = @mass_upload.user
    mail(to: @user.email, subject: '[Fairmondo] Bei deinem CSV-Upload sind Fehler aufgetreten')
  end

  def mass_upload_finished_message mass_upload_id
    @mass_upload = MassUpload.find mass_upload_id
    @user = @mass_upload.user
    subject = '[Fairmondo] Dein CSV-Upload ist abgeschlossen'
    if @mass_upload.articles_for_mass_activation.any?
      subject << '. Es liegen Artikel zur Aktivierung bereit!'
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
