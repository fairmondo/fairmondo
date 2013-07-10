#
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

include Warden::Test::Helpers

describe 'Library' do
  before do
    @user = FactoryGirl.create :user
    login_as @user
  end
  context "without existing libraries" do
    describe "creation" do
      before do
        visit user_libraries_path @user
      end
      context "given valid data" do
        it "should work" do
          page.should have_content I18n.t 'library.new'

          within '#new_library' do
            fill_in 'library_name', with: 'foobar'
            click_button 'Sammlung erstellen'
          end

          page.should have_selector 'a', text: 'foobar'
        end
      end

      context "given invalid data" do
        it "should not work" do
          click_button 'Sammlung erstellen'
          page.should have_content I18n.t 'library.error.presence'
        end
      end
    end
  end

  context "with an existing library" do
    before do
      @lib = FactoryGirl.create :library, name: 'foobar', user: @user
      visit user_libraries_path @user
    end

    describe "update" do
      context "given valid data" do
        it "should work" do
          within "#edit_library_#{@lib.id}" do
            fill_in 'library_name', with: 'bazfuz'
            click_button I18n.t 'formtastic.actions.update'
          end

          page.should have_selector 'a', text: 'bazfuz'
        end
      end
      context "given invalid data" do
        it "should not work" do
          within "#edit_library_#{@lib.id}" do
            fill_in 'library_name', with: ''
            click_button I18n.t 'formtastic.actions.update'
          end

          page.should have_selector 'a', text: 'foobar'
          page.should have_content I18n.t 'library.error.presence'
        end
      end
    end

    describe "destroy" do
      it "should destroy the library" do
        expect do
          within "#library#{@lib.id}" do
            click_link I18n.t('common.actions.destroy')
          end
        end.to change(Library, :count).by(-1)

        page.should_not have_content 'foobar'
      end
    end
  end

  context "with another user's library" do
    before do
      user = FactoryGirl.create :user
      @pub_lib = FactoryGirl.create :library, user: user, public: true
      @priv_lib = FactoryGirl.create :library, user: user, public: false
      visit user_libraries_path user
    end

    it "should show the users public library but not the private one" do
      page.should have_content @pub_lib.name
      page.should_not have_content @priv_lib.name
    end
  end
end

describe "Library Elements" do
  describe "create" do
    it "should work" do
      @user = FactoryGirl.create :user
      login_as @user.reload # reload to get library

      article = FactoryGirl.create :article
      visit article_path(article)

      click_button I18n.t 'common.actions.collect'
      page.should have_content I18n.t('library_element.notice.success')[0..10] # shorten string because library name doesn't get evaluated

      visit user_libraries_path @user
      page.should have_content article.title[0..10] # characters get cut off on page as well
    end
  end
end
