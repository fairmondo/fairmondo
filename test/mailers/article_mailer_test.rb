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
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:article) { FactoryGirl.create(:article) }
  let(:user) { FactoryGirl.create(:user) }

  describe "#report_article" do
    let(:mail) { ArticleMailer.report_article(article,user,"text") }

    it "renders the subject" do
      mail.subject.should have_content("Article reported")
    end

    it "contains the article id" do
      mail.subject.should eq("Article reported with ID: " + article.id.to_s)
    end
  end

  describe "#category_proposal" do
    it "should call the mail function" do
      a = ArticleMailer.send("new")
      a.should_receive(:mail).with(to: $email_addresses['ArticleMailer']['category_proposal'], subject: "Category proposal: foobar" ).and_return true
      a.category_proposal("foobar")
    end
  end

  describe "#contact" do
    let(:mail) { ArticleMailer.contact(user.email, article.seller_email, 'foobar', article) }
    subject { mail }
    it { should have_subject I18n.t('article.show.contact.mail_subject') }

    it { should have_body_text 'foobar' }
    it { should have_body_text user.email }
    it { should have_body_text article.title }
    it { should have_body_text article_url article }

    it { should deliver_to article.seller_email }
  end
end
