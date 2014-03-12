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
require 'spec_helper'

describe ArticleTemplate do

  let(:article_template) { FactoryGirl.create(:article_template) }
  subject { article_template }

  it "should have a valid factory" do
    should be_valid
  end

  describe 'attributes' do
    it { should respond_to :id }
    it { should respond_to :name }
    it { should respond_to :user_id }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }
  end

  describe "associations" do
    it {should belong_to :user}
    it {should have_one(:article).dependent(:destroy)}
    it {should accept_nested_attributes_for :article}
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_uniqueness_of(:name).scoped_to(:user_id)}
    it {should validate_presence_of :user_id}
  end

  describe "methods" do
    # describe "articles_article_template validation" do
    #   before do
    #     article_template = FactoryGirl.build(:article_template)
    #   end
    # end
  end

  describe "methods" do
    describe "::template_request_by user, template_select" do
      it "should return the template when it belongs to the requesting user" do
        t = ArticleTemplate.template_request_by article_template.user, article_template: article_template.id
        t.should eq article_template
      end

      it "should return false when the template does not belong to the user" do
        user = FactoryGirl.create :user
        t = ArticleTemplate.template_request_by user, article_template: article_template.id
        t.should be_false
      end

      it "should return false when no template was selected" do
        t = ArticleTemplate.template_request_by article_template.user, nil
        t.should be_false
      end
    end
  end
def self.template_request_by user, template_select
    if template_select && template_select[:article_template]
      template = ArticleTemplate.find template_select[:article_template]
      user.article_templates.include?(template) ? template : false
    else
      false
    end
  end
end
