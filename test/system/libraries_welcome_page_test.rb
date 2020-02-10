#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibrariesWelcomePageTest < ApplicationSystemTestCase
  setup do
    @user = create :user

    @library = create :public_library_with_elements, name: 'envogue', user: @user
    @library.popularity = 1000
    @library.save

    @admin = create :admin_user
  end

  test 'Personalized library section' do
    # Create two hearts (including new libraries)
    heart1 = create :heart, user: @user
    heart2 = create :heart, user: @user

    # When the user is not logged in, there should be no personalized library section at all.
    visit root_path
    refute page.has_content?(heart1.heartable.name)
    refute page.has_content?(heart2.heartable.name)

    # When the user is logged in has hearted at least two libraries they should be displayed.
    sign_in @user
    visit root_path
    assert page.has_content?(heart1.heartable.name)
    assert page.has_content?(heart2.heartable.name)
  end

  test 'Combined test for trending libraries' do
    sign_in @admin

    # When no libraries are audited, the box on the welcome page should not be displayed
    visit root_path
    refute page.has_content?(I18n.t 'welcome.trending_libraries.heading')

    # enable library for welcome page
    visit libraries_path
    within "#library#{@library.id}" do
      click_on I18n.t 'library.auditing.welcome_page_disabled'
    end

    # visit welcome page, library should be shown
    visit root_path
    assert page.has_content? I18n.t 'welcome.trending_libraries.heading'
    assert page.has_content? 'envogue'

    logout
    sign_in @user
    visit library_path(@library)

    # User should be warned before editing it
    assert page.has_content? I18n.t 'library.auditing.user_warning'

    # User changes the name of an enabled library after which it gets disabled
    fill_in "library#{@library.id}_library_name", with: 'notanymore'
    click_button I18n.t 'formtastic.actions.update'

    # visit welcome page
    visit root_path
    refute page.has_content?('notanymore')
  end
end
