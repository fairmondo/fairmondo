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

feature "Article commendations" do
  setup do
    @seller = FactoryGirl.create :user
    @article = FactoryGirl.create :article, :simple_ecologic, seller: @seller
  end

  scenario "user visits ecologic article" do
    visit article_path(@article)
    page.must_have_link(I18n.t 'formtastic.labels.article.ecologic')
  end

  scenario "user visits seller with ecologic article" do
    visit user_path(@seller)
    page.must_have_link(I18n.t 'formtastic.labels.article.ecologic')
  end
end

feature 'article creation with incorrect social producer questionnaire' do
  setup do
    @user = FactoryGirl.create :user
    login_as @user
    visit new_article_path
    check "article_fair"
    within("#article_fair_kind_input") do
      choose "article_fair_kind_social_producer"
    end
  end

  scenario 'user answers any question with no' do
    click_button I18n.t("article.labels.continue_to_preview")
    page.must_have_content I18n.t('article.form.errors.social_producer_questionnaire.no_social_producer')
  end

  scenario "user selects non profit association without answering any other question with yes" do
    within("#article_social_producer_questionnaire_attributes_nonprofit_association_input") do
      choose "article_social_producer_questionnaire_attributes_nonprofit_association_true"
    end
    click_button I18n.t("article.labels.continue_to_preview")
    find("#article_social_producer_questionnaire_attributes_nonprofit_association_checkboxes_input").must_have_content I18n.t('errors.messages.at_least_one_entry')
  end
end

feature "article creation with incorrect fair trust questionnaire" do
  setup do
    @user = FactoryGirl.create :user
    login_as @user
    visit new_article_path
    check "article_fair"
    within("#article_fair_kind_input") do
      choose "article_fair_kind_fair_trust"
    end
  end

  scenario "user doesn't answer questions 1, 2, and 4" do
    click_button I18n.t("article.labels.continue_to_preview")
    within("#article_fair_trust_questionnaire_attributes_support_input") do
      page.must_have_content I18n.t('errors.messages.blank')
    end
    within("#article_fair_trust_questionnaire_attributes_labor_conditions_input") do
      page.must_have_content I18n.t('errors.messages.blank')
    end
    within("#article_fair_trust_questionnaire_attributes_environment_protection_input") do
      page.wont_have_content I18n.t('errors.messages.blank')
    end
    within("#article_fair_trust_questionnaire_attributes_controlling_input") do
      page.must_have_content I18n.t('errors.messages.blank')
    end
    within("#article_fair_trust_questionnaire_attributes_awareness_raising_input") do
      page.wont_have_content I18n.t('errors.messages.blank')
    end
  end

  scenario "user answers a question with yes but doesn't check a checkbox" do
    within("#article_fair_trust_questionnaire_attributes_support_input") do
      choose "article_fair_trust_questionnaire_attributes_support_true"
    end
    click_button I18n.t("article.labels.continue_to_preview")
    find("#article_fair_trust_questionnaire_attributes_support_checkboxes_input").must_have_content I18n.t('errors.messages.minimum_entries', count: 3)
  end

  scenario "user selects 'other' but doesn't write into the text field" do
    within("#article_fair_trust_questionnaire_attributes_support_input") do
      choose "article_fair_trust_questionnaire_attributes_support_true"
    end
    within("#article_fair_trust_questionnaire_attributes_support_checkboxes_input") do
      check I18n.t('enumerize.fair_trust_questionnaire.support_checkboxes.other')
    end
    click_button I18n.t("article.labels.continue_to_preview")
    find("#article_fair_trust_questionnaire_attributes_support_other_input").must_have_content I18n.t('errors.messages.blank')
  end

end
