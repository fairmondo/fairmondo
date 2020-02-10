#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class FeedbackFormTest < ApplicationSystemTestCase
  setup do
    @user = create :user
    sign_in @user
  end

  test 'user wants help' do
    visit new_feedback_path(variety: 'get_help')

    fill_in 'feedback_from', with: 'test@test.de'
    fill_in 'feedback_subject', with: 'test'
    fill_in 'feedback_text', with: 'testtesttest'

    select I18n.t('enumerize.feedback.help_subject.marketplace'), from: I18n.t('formtastic.labels.feedback.help_subject')

    FeedbackMailer.any_instance.expects(:mail)
    click_button I18n.t 'feedback.actions.get_help'
    assert page.has_content? I18n.t 'article.actions.reported'
  end

  test 'user sends feedback' do
    visit new_feedback_path(variety: 'send_feedback')

    fill_in 'feedback_from', with: 'test@test.de'
    fill_in 'feedback_subject', with: 'test'
    fill_in 'feedback_text', with: 'testtesttest'

    select I18n.t('enumerize.feedback.feedback_subject.dealer'), from: I18n.t('formtastic.labels.feedback.feedback_subject')

    FeedbackMailer.any_instance.expects(:mail)
    click_button I18n.t 'feedback.actions.send_feedback'
    assert page.has_content? I18n.t 'article.actions.reported'
  end

  test 'user sends on 1st try false feedback and on 2nd try true feedback' do
    article = create :article
    visit article_path(article)

    click_button I18n.t 'feedback.actions.send_feedback'

    fill_in 'feedback_text', with: 'testtesttest'

    click_button I18n.t 'feedback.actions.send_feedback'
    assert_equal(article_path(article), current_path)
  end
end
