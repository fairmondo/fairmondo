#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'User ratings' do
  let(:buyer) { create :user }
  let(:line_item_group) { create :line_item_group, :with_business_transactions, :sold, buyer: buyer }

  scenario 'guest rates a line_item_group' do
    visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)
    current_path.must_equal new_user_session_path
  end

  scenario "user rates a line_item_group he didn't make" do
    login_as create :user
    -> { visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group) }.must_raise Pundit::NotAuthorizedError
  end

  scenario 'user gives a rating for a line_item_group he made' do
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

  scenario 'user tries to give a rating without entering a value' do
    login_as buyer
    visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)
    click_button 'Bewertung speichern'
    page.must_have_button 'Bewertung speichern' # test if still on same page
  end

  scenario 'user tries to rate a line_item_group a second time' do
    login_as buyer
    rating = create(:positive_rating)
    -> { visit line_item_group_new_user_rating_path(rating.rated_user, rating.line_item_group) }.must_raise Pundit::NotAuthorizedError
  end

  scenario 'user visits profile of another user and checks his ratings' do
    @rating = create :rating_with_text, line_item_group: line_item_group,
                                        rated_user: line_item_group.seller,
                                        rating_user: line_item_group.buyer
    login_as line_item_group.buyer
    visit user_ratings_path(user_id: line_item_group.seller.id)

    page.must_have_content(line_item_group.seller.nickname)
    page.must_have_content(@rating.text)
    page.must_have_content(line_item_group.buyer.nickname)
  end
end
