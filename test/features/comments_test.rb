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
  scenario "User visits library with no comments" do
    library = FactoryGirl.create(:library, public: true)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content("Keine Kommentare")
    end
  end

  scenario "User visits library with a comment" do
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
    end
  end

end
