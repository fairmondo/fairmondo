#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleFairTrustQuestionnaireTest < ApplicationSystemTestCase
  setup do
    @user = create :user
    sign_in @user
    visit new_article_path
    check 'article_fair'
    within('#article_fair_kind_input') do
      choose 'article_fair_kind_fair_trust'
    end
  end

  test "user doesn't answer questions 1, 2, and 4" do
    click_button I18n.t('article.labels.continue_to_preview')
    within('#article_fair_trust_questionnaire_attributes_support_input') do
      assert page.has_content? I18n.t('errors.messages.blank')
    end
    within('#article_fair_trust_questionnaire_attributes_labor_conditions_input') do
      assert page.has_content? I18n.t('errors.messages.blank')
    end
    within('#article_fair_trust_questionnaire_attributes_environment_protection_input') do
      page.wont_have_content I18n.t('errors.messages.blank')
    end
    within('#article_fair_trust_questionnaire_attributes_controlling_input') do
      assert page.has_content? I18n.t('errors.messages.blank')
    end
    within('#article_fair_trust_questionnaire_attributes_awareness_raising_input') do
      page.wont_have_content I18n.t('errors.messages.blank')
    end
  end

  test "user answers a question with yes but doesn't check a checkbox" do
    within('#article_fair_trust_questionnaire_attributes_support_input') do
      choose 'article_fair_trust_questionnaire_attributes_support_true'
    end
    click_button I18n.t('article.labels.continue_to_preview')
    find('#article_fair_trust_questionnaire_attributes_support_checkboxes_input').must_have_content I18n.t('errors.messages.minimum_entries', count: 3)
  end

  test "user selects 'other' but doesn't write into the text field" do
    within('#article_fair_trust_questionnaire_attributes_support_input') do
      choose 'article_fair_trust_questionnaire_attributes_support_true'
    end
    within('#article_fair_trust_questionnaire_attributes_support_checkboxes_input') do
      check I18n.t('enumerize.fair_trust_questionnaire.support_checkboxes.other')
    end
    click_button I18n.t('article.labels.continue_to_preview')
    find('#article_fair_trust_questionnaire_attributes_support_other_input').must_have_content I18n.t('errors.messages.blank')
  end
end
