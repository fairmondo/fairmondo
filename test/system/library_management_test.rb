#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibraryManagementTest < ApplicationSystemTestCase
  setup do
    @user = create :user
    sign_in @user.reload # reload to get default library
  end

  test 'user creates new library' do
    visit user_libraries_path @user
    assert page.has_content? I18n.t 'library.new'
    within '#new_library' do
      fill_in 'new_library_name', with: 'foobar'
      click_button I18n.t('library.create')
    end
    page.must_have_selector 'a', text: 'foobar'
  end

  test 'user creates a library with a blank name' do
    visit user_libraries_path @user
    click_button I18n.t('library.create')
    assert page.has_content? I18n.t 'activerecord.errors.models.library.attributes.name.blank'
  end

  test 'user updates name of existing Library' do
    library = create :library, name: 'foobar', user: @user
    visit user_libraries_path @user
    click_link 'foobar'
    within "#edit_library_#{library.id}" do
      fill_in "library#{library.id}_library_name", with: 'bazfuz'
      click_button I18n.t 'formtastic.actions.update'
    end
    assert page.has_content? 'bazfuz'
  end

  test 'user updates library with a blank name' do
    library = create :library, name: 'foobar', user: @user
    visit user_libraries_path @user
    click_link 'foobar'
    within "#edit_library_#{library.id}" do
      fill_in "library#{library.id}_library_name", with: ''
      click_button I18n.t 'formtastic.actions.update'
    end

    assert page.has_content? 'foobar'
    assert page.has_content? I18n.t('activerecord.errors.models.library.attributes.name.blank')
  end

  test 'user deletes Library' do
    create :library, name: 'foobar', user: @user
    visit user_libraries_path @user
    click_link 'foobar'
    assert_difference 'Library.count', -1 do
      within '.library-edit-settings' do
        click_link I18n.t('library.delete')
      end
    end
    page.wont_have_content 'foobar'
  end

  test 'user adds an Article to his default Library' do
    @article = create :article
    visit article_path(@article)
    assert page.has_css?('div#libraries_list a', count: 1) # There should be exactly one library link (default library) before adding

    within '#libraries_list' do
      click_link I18n.t 'library.default'
    end
    assert page.has_content? I18n.t('library_element.notice.success')[0..10] # shorten string because library name doesn't get evaluated
    assert page.has_css?('div#libraries_list a', count: 0) # After adding the article, the library link should be removed

    visit user_libraries_path @user
    click_link I18n.t 'library.default'
    assert page.has_content? @article.title[0..10] # characters get cut off on page as well
  end

  test 'seller removes an article that buyer has in his library' do
    seller = @user
    article = create :article, seller: seller
    buyer = create :buyer
    library = create :library, user: buyer, public: true
    create :library_element, article: article, library: library

    sign_in seller
    visit article_path article
    click_button I18n.t('article.labels.deactivate')
    logout(:user)
    sign_in buyer
    visit library_path library
    assert page.has_content? I18n.t('common.text.no_articles')
  end
end
