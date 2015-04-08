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
require_relative '../test_helper'

describe ArticleMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:article) { FactoryGirl.create(:article) }
  let(:mass_upload) { FactoryGirl.create(:mass_upload) }
  let(:user) { FactoryGirl.create(:user) }

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
    mail = ArticleMailer.article_activation_message(article)

    mail.must deliver_to article.seller_email
  end

  it '#mass_upload_activation_message' do
    mail = ArticleMailer.mass_upload_activation_message(mass_upload)

    mail.must deliver_to mass_upload.user.email
  end

  it '#mass_upload_processed_message' do
    mail = ArticleMailer.mass_upload_finished_message(mass_upload)

    mail.must deliver_to mass_upload.user.email
  end

  it '#mass_upload_failed_message' do
    mail = ArticleMailer.mass_upload_failed_message(mass_upload)

    mail.must deliver_to mass_upload.user.email
  end
end
