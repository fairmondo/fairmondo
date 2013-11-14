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
require 'spec_helper'

include Warden::Test::Helpers

describe "Feedback" do

  describe "get_help" do
    it "should work" do
      @user = FactoryGirl.create :user
      login_as @user

      visit new_feedback_path(:variety => "get_help")

      fill_in 'feedback_from', with: 'test@test.de'
      fill_in 'feedback_subject', with: 'test'
      fill_in 'feedback_text', with: 'testtesttest'

      select I18n.t("enumerize.feedback.help_subject.marketplace"), from: I18n.t('formtastic.labels.feedback.help_subject')

      FeedbackMailer.any_instance.should_receive(:mail)
      click_button I18n.t 'feedback.actions.get_help'
      page.should have_content I18n.t 'article.actions.reported'
    end
  end

  describe "send_feedback" do
    it "should work" do
      @user = FactoryGirl.create :user
      login_as @user

      visit new_feedback_path(:variety => "send_feedback")

      fill_in 'feedback_from', with: 'test@test.de'
      fill_in 'feedback_subject', with: 'test'
      fill_in 'feedback_text', with: 'testtesttest'

      select I18n.t("enumerize.feedback.feedback_subject.dealer"), from: I18n.t('formtastic.labels.feedback.feedback_subject')

      FeedbackMailer.any_instance.should_receive(:mail)
      click_button I18n.t 'feedback.actions.send_feedback'
      page.should have_content I18n.t 'article.actions.reported'
    end
  end

  describe "become_donation_partner" do
    it "should work" do
      @user = FactoryGirl.create :user
      login_as @user

      visit new_feedback_path(:variety => "become_donation_partner")

      fill_in 'feedback_forename', with: 'test'
      fill_in 'feedback_lastname', with: 'test'
      fill_in 'feedback_from', with: 'test@test.de'
      fill_in 'feedback_organisation', with: 'test'
      fill_in 'feedback_text', with: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest'

      FeedbackMailer.any_instance.should_receive(:mail)
      click_button I18n.t 'feedback.actions.become_donation_partner'
      page.should have_content I18n.t 'article.actions.reported'

    end
  end

end
