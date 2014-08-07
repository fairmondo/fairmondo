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
include FastBillStubber

feature 'User ratings' do

  let(:buyer) { FactoryGirl.create :user }
  let(:line_item_group) { FactoryGirl.create :line_item_group, :with_business_transactions, :sold, buyer: buyer }

  scenario "guest rates a line_item_group" do
    visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)
    current_path.must_equal new_user_session_path
  end

  scenario "user rates a line_item_group he didn't make" do
    login_as  FactoryGirl.create :user
    -> { visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group) }.must_raise Pundit::NotAuthorizedError
  end

  scenario "user gives a rating for a line_item_group he made" do
    login_as buyer
    visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)

    page.must_have_selector "input#rating_rating_positive[@value='positive']"
    page.must_have_selector "input#rating_rating_neutral[@value='neutral']"
    page.must_have_selector "input#rating_rating_negative[@value='negative']"

    page.must_have_button 'Bewertung speichern'
    choose 'rating_rating_positive'
    click_button 'Bewertung speichern'
    current_path.must_equal user_path(buyer)
    page.must_have_content 'Deine Bewertung wurde gespeichert'
  end

  scenario "user tries to give a rating without entering a value" do
    login_as buyer
    visit line_item_group_new_user_rating_path(line_item_group.seller,line_item_group)
    click_button 'Bewertung speichern'
    page.must_have_button 'Bewertung speichern' # test if still on same page
  end

  scenario "user tries to rate a line_item_group a second time" do
    login_as buyer
    rating = FactoryGirl.create(:positive_rating)
    -> { visit line_item_group_new_user_rating_path(rating.rated_user, rating.line_item_group) }.must_raise Pundit::NotAuthorizedError
  end

  scenario "user visits profile of another user and checks his ratings" do
    @rating = FactoryGirl.create :rating, rated_user: line_item_group.seller, rating_user: line_item_group.buyer, line_item_group: line_item_group
    login_as line_item_group.buyer
    visit user_ratings_path(:user_id => line_item_group.seller.id)

    page.must_have_content(line_item_group.seller.nickname)
    page.must_have_content(@rating.text)
    page.must_have_content(line_item_group.buyer.nickname)
  end
end
