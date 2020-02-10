#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleSocialProducerQuestionnaireTest < ApplicationSystemTestCase
  setup do
    @user = create :user
    sign_in @user
    visit new_article_path
    check 'article_fair'
    within('#article_fair_kind_input') do
      choose 'article_fair_kind_social_producer'
    end
  end

  test 'user answers any question with no' do
    click_button I18n.t('article.labels.continue_to_preview')
    assert page.has_content? I18n.t('article.form.errors.social_producer_questionnaire.no_social_producer')
  end

  test 'user selects non profit association without answering any other question with yes' do
    within('#article_social_producer_questionnaire_attributes_nonprofit_association_input') do
      choose 'article_social_producer_questionnaire_attributes_nonprofit_association_true'
    end
    click_button I18n.t('article.labels.continue_to_preview')
    find('#article_social_producer_questionnaire_attributes_nonprofit_association_checkboxes_input').must_have_content I18n.t('errors.messages.at_least_one_entry')
  end
end
