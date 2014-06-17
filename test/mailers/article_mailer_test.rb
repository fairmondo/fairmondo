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
require "test_helper"

describe ArticleMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:article) { FactoryGirl.create(:article) }
  let(:user) { FactoryGirl.create(:user) }

  it "#report_article" do
    mail =  ArticleMailer.report_article(article,user,"text")
    mail.subject.must_include("Article reported")
    mail.subject.must_equal("Article reported with ID: " + article.id.to_s)
  end

  it "#category_proposal" do
    mail = ArticleMailer.category_proposal("foobar")
    mail.must deliver_to $email_addresses['ArticleMailer']['category_proposal']
    mail.must have_subject "Category proposal: foobar"
  end

  it "#contact" do
    mail =  ArticleMailer.contact(user.email, article.seller_email, 'foobar', article)

    mail.must have_subject I18n.t('article.show.contact.mail_subject')

    mail.must have_body_text 'foobar'
    mail.must have_body_text user.email
    mail.must have_body_text article.title
    mail.must have_body_text article_url article

    mail.must deliver_to article.seller_email
  end
end
