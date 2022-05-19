#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserRatingsTest < ApplicationSystemTestCase
  let(:buyer) { create :user }
  let(:line_item_group) { create :line_item_group, :with_business_transactions, :sold, buyer: buyer }

  test 'guest rates a line_item_group' do
    visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)
    assert_equal new_user_session_path, current_path
  end

  test "user rates a line_item_group he didn't make" do
    sign_in create :user

    # TODO: Should this not be handled instead?
    assert_raises Pundit::NotAuthorizedError do
      visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)
    end
  end

  test 'user gives a rating for a line_item_group he made' do
    sign_in buyer
    visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)

    assert "input#rating_rating_positive[value='positive']"
    assert "input#rating_rating_neutral[value='neutral']"
    assert "input#rating_rating_negative[value='negative']"

    assert page.has_button? 'Bewertung speichern'
    choose 'rating_rating_positive', allow_label_click: true
    click_button 'Bewertung speichern'
    assert_equal user_path(buyer), current_path
    assert page.has_content? 'Deine Bewertung wurde gespeichert'
  end

  test 'user tries to give a rating without entering a value' do
    sign_in buyer
    visit line_item_group_new_user_rating_path(line_item_group.seller, line_item_group)
    click_button 'Bewertung speichern'
    assert page.has_button? 'Bewertung speichern' # test if still on same page
  end

  test 'user tries to rate a line_item_group a second time' do
    sign_in buyer
    rating = create(:positive_rating)
    # TODO: Should this not be handled instead?
    assert_raises Pundit::NotAuthorizedError do
      visit line_item_group_new_user_rating_path(rating.rated_user, rating.line_item_group)
    end
  end

  test 'user visits profile of another user and checks his ratings' do
    @rating = create :rating_with_text, line_item_group: line_item_group,
                                        rated_user: line_item_group.seller,
                                        rating_user: line_item_group.buyer
    sign_in line_item_group.buyer
    visit user_ratings_path(user_id: line_item_group.seller.id)

    assert page.has_content?(line_item_group.seller.nickname)
    assert page.has_content?(@rating.text)
    assert page.has_content?(line_item_group.buyer.nickname)
  end
end
