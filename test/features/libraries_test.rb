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
require_relative '../test_helper'

include Warden::Test::Helpers

feature 'Library management' do
  setup do
    @user = FactoryGirl.create :user
    login_as @user.reload # reload to get default library
  end

  scenario "user creates new library" do
    visit user_libraries_path @user
    page.must_have_content I18n.t 'library.new'
    within '#new_library' do
      fill_in 'library_name', with: 'foobar'
      click_button I18n.t('library.create')
    end
    page.must_have_selector 'a', text: 'foobar'
  end

  scenario "user creates a library with a blank name" do
    visit user_libraries_path @user
    click_button I18n.t('library.create')
    page.must_have_content I18n.t 'activerecord.errors.models.library.attributes.name.blank'
  end

  scenario "user updates name of exsisting Library" do
    library = FactoryGirl.create :library, name: 'foobar', user: @user
    visit user_libraries_path @user
    within "#edit_library_#{library.id}" do
      fill_in 'library_name', with: 'bazfuz'
      click_button I18n.t 'formtastic.actions.update'
    end
    page.must_have_selector 'a', text: 'bazfuz'
  end


  scenario "user updates library with a blank name" do
    library = FactoryGirl.create :library, name: 'foobar', user: @user
    visit user_libraries_path @user
    within "#edit_library_#{library.id}" do
      fill_in 'library_name', with: ''
      click_button I18n.t 'formtastic.actions.update'
    end

    page.must_have_selector 'a', text: 'foobar'
    page.must_have_content I18n.t('activerecord.errors.models.library.attributes.name.blank')

  end

  scenario "user deletes Library" do
    library = FactoryGirl.create :library, name: 'foobar', user: @user
    visit user_libraries_path @user
    assert_difference 'Library.count', -1 do
      within "#library#{library.id}" do
        click_link I18n.t('common.actions.destroy')
      end
    end
    page.wont_have_content 'foobar'
  end

  scenario "user adds an Article to his default Library" do
    @article = FactoryGirl.create :article
    visit article_path(@article)
    click_link I18n.t 'library.default'
    page.must_have_content I18n.t('library_element.notice.success')[0..10] # shorten string because library name doesn't get evaluated
    visit user_libraries_path @user
    page.must_have_content @article.title[0..10] # characters get cut off on page as well
  end

  scenario 'user adds a library element twice' do
    @article = FactoryGirl.create :article
    visit article_path(@article)
    click_link I18n.t 'library.default'
    click_link I18n.t 'library.default'
    page.must_have_content I18n.t('library_element.notice.failure')
  end

  scenario "seller removes an article that buyer has in his library" do
    seller = @user
    article = FactoryGirl.create :article, seller: seller
    buyer = FactoryGirl.create :buyer
    library = FactoryGirl.create :library, :user => buyer, :public => true
    FactoryGirl.create :library_element, :article => article, :library => library

    login_as seller
    visit article_path article
    click_button I18n.t('article.labels.deactivate')

    login_as buyer
    visit user_libraries_path buyer
    within("#library"+library.id.to_s) do
      page.must_have_content I18n.t 'library.no_products'
    end
  end

end

feature 'Library visibility' do
  before do
    UserTokenGenerator.stubs( :generate ).returns("some long string that is very secret")
  end
  scenario "user browses through libraries" do
    user = FactoryGirl.create :user
    pub_lib = FactoryGirl.create :library, user: user, public: true
    pub_lib.articles << FactoryGirl.create(:article, title: 'exhibit-article')
    priv_lib = FactoryGirl.create :library, user: user, public: false
    visit user_libraries_path user
    page.must_have_content pub_lib.name
    page.wont_have_content priv_lib.name

  end
end


feature "Featured (exhibited) libraries" do
  scenario "user visits root path with exhibition" do
    lib = FactoryGirl.create :library, :public, exhibition_name: 'queue1'
    lib.articles << FactoryGirl.create(:article, title: 'exhibit-article')
    visit root_path
    page.must_have_content 'exhibit-article'
  end

  scenario "user vistits book category front page" do
    lib = FactoryGirl.create :library, :public, exhibition_name: 'book1'
    lib.articles << FactoryGirl.create(:article, title: 'exhibit-article')
    visit category_path FactoryGirl.create :category, name: 'bucher'
    page.must_have_content 'exhibit-article'
  end
end

feature "Admin management for featured (exhibited) Libraries" do
  let(:featured_library) { FactoryGirl.create :library, :public, exhibition_name: 'donation_articles' }
  let(:article) { FactoryGirl.create :article, title: 'Foobar' }
  setup do
    login_as FactoryGirl.create :admin_user
  end

  scenario "admin adds Article to a random Library" do
    visit root_path
    page.wont_have_link 'Foobar'

    featured_library
    visit article_path article
    select(I18n.t('enumerize.library.exhibition_name.donation_articles'), from: 'library_exhibition_name')
    click_button I18n.t 'article.show.add_as_exhibit'

    visit root_path
    page.must_have_link 'Foobar'
  end

  scenario "admin add Article that is already in the library" do
    featured_library.articles << article
    visit article_path article
    select(I18n.t('enumerize.library.exhibition_name.donation_articles'), from: 'library_exhibition_name')

    assert_no_difference 'featured_library.articles.count' do
      click_button I18n.t 'article.show.add_as_exhibit'
    end
  end

  scenario "admin removes an article" do
    featured_library.articles << article
    visit article_path article

    click_button 'aus *Spendenanteil*-Artikel löschen'
    visit root_path

    page.wont_have_link 'Foobar'
  end

  scenario "admin sets a library as featured" do
    featured_library
    other_library = FactoryGirl.create :library, :public

    visit library_path other_library
    select(I18n.t('enumerize.library.exhibition_name.donation_articles'), from: 'library_exhibition_name')
    find('#select_exhibition_submit_action').click

    other_library.reload.exhibition_name.must_equal 'donation_articles'
    featured_library.reload.exhibition_name.must_equal nil
  end
end
