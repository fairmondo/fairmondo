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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly. If not, see <http://www.gnu.org/licenses/>.
#
require_relative "../test_helper"

include Warden::Test::Helpers

feature "comments for all users" do
  before do
    UserTokenGenerator.stubs( :generate ).returns("some long string that is very secret")
  end
  scenario "Guest visits library with no comments" do
    library = FactoryGirl.create(:library, public: true)
    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content("Du kannst keine Kommentare erstellen.")
      page.wont_have_content("Kommentar erstellen")
    end
  end

  scenario "Guest visits library with no comments" do
    library = FactoryGirl.create(:library, public: true)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content("Keine Kommentare")
    end
  end

  scenario "Guest visits library with a comment" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: library,
                                 library: library,
                                 user: user)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content("Test comment")
      page.wont_have_content("Keine Kommentare")
      page.wont_have_content("Mehr Kommentare")
    end
  end

  scenario "Guest visits library with more than 5 comments" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    comment = FactoryGirl.create_list(:comment,
                                 10,
                                 text: "Test comment",
                                 commentable: library,
                                 library: library,
                                 user: user)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content("Mehr Kommentare")
    end
  end

  scenario "User visits library to create a comment" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    login_as user

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content("Kommentar erstellen")
    end
  end

  scenario "User is able to delete their own comment" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    login_as user
    comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: library,
                                 library: library,
                                 user: user)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content("Kommentar löschen")
    end
  end

  scenario "Guest is unable to delete a comment" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: library,
                                 library: library,
                                 user: user)

    visit library_path(library)

    within(".Comments-section") do
      page.wont_have_content("Kommentar löschen")
    end
  end

  scenario "User is unable to delete other users comments" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    login_as user2

    comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: library,
                                 library: library,
                                 user: user)

    visit library_path(library)

    within(".Comments-section") do
      page.wont_have_content("Kommentar löschen")
    end

  end

  scenario "Guest is able to see the last two comments" +
           " of a library on the overview" do
    library = FactoryGirl.create(:library, public: true)
    article = FactoryGirl.create(:article)
    article.libraries << library
    user = FactoryGirl.create(:user)
    comment = FactoryGirl.create_pair(:comment,
                                      text: "Test comment",
                                      commentable: library,
                                      library: library,
                                      user: user)

    visit libraries_path

    within("#library#{library.id} .library-comments") do
      page.must_have_content("Test comment")
    end

  end
end
