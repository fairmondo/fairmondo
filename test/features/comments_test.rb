# -*- coding: utf-8 -*-
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
      page.must_have_content(I18n.t('comments.login_to_comment', href: I18n.t('comments.login_href')))
      page.wont_have_content(I18n.t('comments.create'))
    end
  end

  scenario "Guest visits library with no comments" do
    library = FactoryGirl.create(:library, public: true)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_content(I18n.t('comments.no_comments'))
    end
  end

  scenario "Guest visits library with a comment" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: library,
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
                                 user: user)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_selector(".fa-times")
    end
  end

  scenario "Admin is able to delete another's comment" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:admin_user)
    login_as user
    comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: library,
                                 user: library.user)

    visit library_path(library)

    within(".Comments-section") do
      page.must_have_selector(".fa-times")
    end
  end

  scenario "Guest is unable to delete a comment" do
    library = FactoryGirl.create(:library, public: true)
    user = FactoryGirl.create(:user)
    comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: library,
                                 user: user)

    visit library_path(library)

    within(".Comments-section") do
      refute page.has_selector?(".fa-times")
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
                                      user: user)

    visit libraries_path

    within("#library#{library.id} .Library-comments") do
      page.must_have_content("Test comment")
    end
  end
end

feature "comments on articles" do
  scenario "User visits article to create a comment" do
    article = FactoryGirl.create :article
    user = FactoryGirl.create(:user)
    login_as user

    visit article_path(article)

    within(".Comments-section") do
      page.must_have_content("Kommentar erstellen")
    end
  end

  scenario "User can't create a comment on a vacationing seller's article" do
    article = FactoryGirl.create(:article, seller: FactoryGirl.create(:seller, vacationing: true))
    user = FactoryGirl.create(:user)
    login_as user

    visit article_path(article)
    refute page.has_selector?('#new_comment_1')
  end

  scenario "A comment on a legal entity's article wont be shown after 5pm" do
    article = FactoryGirl.create(:article, seller: FactoryGirl.create(:legal_entity))
    user = FactoryGirl.create(:user)
    login_as user
    time5pm = (Time.now.utc.beginning_of_day + 17.hours)
    comment1 = FactoryGirl.create(:comment,
                               text: 'Earlier Comment',
                               commentable: article,
                               user: user,
                               created_at: time5pm - 1.minute)
    comment2 = FactoryGirl.create(:comment,
                               text: 'Later Comment',
                               commentable: article,
                               user: user,
                               created_at: time5pm + 1.minute)

    Time.stubs(:now).returns(time5pm + 2.minutes)
    visit article_path(article)
    assert page.has_content? 'Earlier Comment'
    refute page.has_content? 'Later Comment'

    Time.stubs(:now).returns(time5pm + 1.day)
    visit article_path(article)
    assert page.has_content? 'Later Comment'
  end

  scenario "A comment on a legal entity's article wont be shown before 10am" do
    article = FactoryGirl.create(:article, seller: FactoryGirl.create(:legal_entity))
    user = FactoryGirl.create(:user)
    login_as user
    time10am = (Time.now.utc.beginning_of_day + 10.hours)
    comment1 = FactoryGirl.create(:comment,
                               text: 'Some Comment',
                               commentable: article,
                               user: user,
                               created_at: time10am - 2.minutes)

    Time.stubs(:now).returns(time10am - 1.minute)
    visit article_path(article)
    refute page.has_content? 'Some Comment'

    Time.stubs(:now).returns(time10am + 1.minute)
    visit article_path(article)
    assert page.has_content? 'Some Comment'
  end
end
