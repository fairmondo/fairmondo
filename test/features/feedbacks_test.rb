#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'Give Feedback' do
  setup do
    @user = FactoryGirl.create :user
    login_as @user
  end
  scenario 'user wants help' do
    visit new_feedback_path(variety: 'get_help')

    fill_in 'feedback_from', with: 'test@test.de'
    fill_in 'feedback_subject', with: 'test'
    fill_in 'feedback_text', with: 'testtesttest'

    select I18n.t('enumerize.feedback.help_subject.marketplace'), from: I18n.t('formtastic.labels.feedback.help_subject')

    FeedbackMailer.any_instance.expects(:mail)
    click_button I18n.t 'feedback.actions.get_help'
    page.must_have_content I18n.t 'article.actions.reported'
  end

  scenario 'user sends feedback' do
    visit new_feedback_path(variety: 'send_feedback')

    fill_in 'feedback_from', with: 'test@test.de'
    fill_in 'feedback_subject', with: 'test'
    fill_in 'feedback_text', with: 'testtesttest'

    select I18n.t('enumerize.feedback.feedback_subject.dealer'), from: I18n.t('formtastic.labels.feedback.feedback_subject')

    FeedbackMailer.any_instance.expects(:mail)
    click_button I18n.t 'feedback.actions.send_feedback'
    page.must_have_content I18n.t 'article.actions.reported'
  end

  # scenario "user wants to be donation_partner" do
  #
  #   visit new_feedback_path(:variety => "become_donation_partner")

  #   fill_in 'feedback_forename', with: 'test'
  #   fill_in 'feedback_lastname', with: 'test'
  #   fill_in 'feedback_from', with: 'test@test.de'
  #   fill_in 'feedback_organisation', with: 'test'
  #   fill_in 'feedback_text', with: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest'
  #   FeedbackMailer.any_instance.expects(:mail)
  #   click_button I18n.t 'feedback.actions.become_donation_partner'
  #   page.must_have_content I18n.t 'article.actions.reported'
  #
  # end
end
