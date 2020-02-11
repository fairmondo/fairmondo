#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ArticleMailerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:article) { create(:article) }
  let(:mass_upload) { create(:mass_upload) }
  let(:user) { create(:user) }

  it '#report_article' do
    mail =  ArticleMailer.report_article(article, user, 'text')
    mail.subject.must_include('Article reported')
    mail.subject.must_equal('Article reported with ID: ' + article.id.to_s)
  end

  it '#contact' do
    mail =  ArticleMailer.contact(sender: user, resource_id: article.id, text: 'foobar')

    mail.must deliver_to article.seller_email
    mail.must have_subject I18n.t('article.show.contact.mail_subject')

    mail.must have_body_text 'foobar'
    mail.must have_body_text user.email
    mail.must have_body_text article.title
    mail.must have_body_text article_url article
  end

  it '#article_activation_message' do
    mail = ArticleMailer.article_activation_message(article.id)

    mail.must deliver_to article.seller_email
  end

  it '#mass_upload_activation_message' do
    mail = ArticleMailer.mass_upload_activation_message(mass_upload.id)

    mail.must deliver_to mass_upload.user.email
  end

  it '#mass_upload_finished_message' do
    mail = ArticleMailer.mass_upload_finished_message(mass_upload.id)

    mail.must deliver_to mass_upload.user.email
    mail.must have_body_text 'mass_upload_correct.csv'
  end

  it '#mass_upload_failed_message' do
    mail = ArticleMailer.mass_upload_failed_message(mass_upload.id)

    mail.must deliver_to mass_upload.user.email
    mail.must have_body_text 'mass_upload_correct.csv'
  end
end
