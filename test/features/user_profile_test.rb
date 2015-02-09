#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

include Warden::Test::Helpers

feature 'User profile page' do

  scenario "user visits his profile" do
    @user = FactoryGirl.create :user
    login_as @user
    visit user_path(@user)
    page.must_have_content("Profil bearbeiten")
    page.must_have_content("Sammlungen")
    page.wont_have_content('Admin')
  end

  scenario 'user looks at his profile' do
    @user = FactoryGirl.create :user
    login_as @user
    visit profile_user_path(@user)
    page.must_have_content @user.nickname
  end

  scenario "guest visits another users profile through an article" do
    article = FactoryGirl.create :article
    visit article_path article
    find('.User-image a').click
    current_path.must_equal user_path article.seller
  end

  scenario "guests visits a legal entity's profile page" do
    user = FactoryGirl.create :legal_entity
    visit user_path user
    click_link I18n.t 'common.text.about_terms_short'
    current_path.must_equal profile_user_path user
  end
end

feature 'contacting users' do
  before do
    receiver = FactoryGirl.create :legal_entity
    sender   = FactoryGirl.create :user
    login_as sender
    visit profile_user_path receiver
    click_link I18n.t 'users.profile.contact.heading'
  end

  scenario "user contacts seller" do
    fill_in 'contact[text]', with: 'foobar'
    click_button I18n.t('users.profile.contact.action')
    page.must_have_content I18n.t 'users.profile.contact.success_notice'
  end

  scenario "user contacts seller but unchecks email transfer acceptance" do
    fill_in 'contact[text]', with: 'foobar'
    uncheck 'contact[email_transfer_accepted]'
    click_button I18n.t('users.profile.contact.action')
    page.must_have_content I18n.t 'users.profile.contact.acceptance_error'
  end

  scenario "user contacts seller with blank message" do
    fill_in 'contact[text]', with: ''
    click_button I18n.t('users.profile.contact.action')
    page.must_have_content I18n.t 'users.profile.contact.empty_error'
  end

  scenario "user contacts seller with message that exceeds 2000 character limit" do
    text = ''
    2001.times { text += 'a' }
    fill_in 'contact[text]', with: text
    click_button I18n.t('users.profile.contact.action')
    page.must_have_content I18n.t 'users.profile.contact.long_error'
  end
end
