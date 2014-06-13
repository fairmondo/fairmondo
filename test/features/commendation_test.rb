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
require 'test_helper'

include Warden::Test::Helpers

describe 'Commendation Validations' do

  context "for signed-in users" do

    before :each do
      @user = FactoryGirl.create :user
      login_as @user, scope: :user
      visit new_article_path
    end

    describe "article creation with incorrect commendations" do
      context "social producer questionnaire" do

        before do
          check "article_fair"
          within("#article_fair_kind_input") do
            choose "article_fair_kind_social_producer"
          end
        end

        it "should throw an error if you don't answer any questions" do
          find(".actions").find(".action").find("input").click
          page.should have_content I18n.t('article.form.errors.social_producer_questionnaire.no_social_producer')
        end

        it "should throw an error if you answer a question with yes but don't check a checkbox" do
          within("#article_social_producer_questionnaire_attributes_nonprofit_association_input") do
            choose "article_social_producer_questionnaire_attributes_nonprofit_association_true"
          end
          find(".actions").find(".action").find("input").click
          find("#article_social_producer_questionnaire_attributes_nonprofit_association_checkboxes_input").should have_content I18n.t('errors.messages.at_least_one_entry')
        end
      end

      context "fair trust questionnaire" do
        before do
          check "article_fair"
          within("#article_fair_kind_input") do
            choose "article_fair_kind_fair_trust"
          end
        end

        it "should throw an error if you don't answer questions 1, 2, and 4" do
          find(".actions").find(".action").find("input").click
          within("#article_fair_trust_questionnaire_attributes_support_input") do
            page.should have_content I18n.t('errors.messages.blank')
          end
          within("#article_fair_trust_questionnaire_attributes_labor_conditions_input") do
            page.should have_content I18n.t('errors.messages.blank')
          end
          within("#article_fair_trust_questionnaire_attributes_environment_protection_input") do
            page.should_not have_content I18n.t('errors.messages.blank')
          end
          within("#article_fair_trust_questionnaire_attributes_controlling_input") do
            page.should have_content I18n.t('errors.messages.blank')
          end
          within("#article_fair_trust_questionnaire_attributes_awareness_raising_input") do
            page.should_not have_content I18n.t('errors.messages.blank')
          end
        end

        it "should throw an error if you answer a question with yes but don't check a checkbox" do
          within("#article_fair_trust_questionnaire_attributes_support_input") do
            choose "article_fair_trust_questionnaire_attributes_support_true"
          end
          find(".actions").find(".action").find("input").click
          find("#article_fair_trust_questionnaire_attributes_support_checkboxes_input").should have_content I18n.t('errors.messages.minimum_entries', count: 3)
        end

        it "should throw an error if you select 'other' but don't write into the text field" do
          within("#article_fair_trust_questionnaire_attributes_support_input") do
            choose "article_fair_trust_questionnaire_attributes_support_true"
          end
          within("#article_fair_trust_questionnaire_attributes_support_checkboxes_input") do
            check I18n.t('enumerize.fair_trust_questionnaire.support_checkboxes.other')
          end
          find(".actions").find(".action").find("input").click
          find("#article_fair_trust_questionnaire_attributes_support_other_input").should have_content I18n.t('errors.messages.blank')
        end
      end
    end
  end
end
