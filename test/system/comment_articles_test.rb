#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class CommentArticlesTest < ApplicationSystemTestCase
  test 'User visits article to create a comment' do
    article = create :article
    user = create(:user)
    sign_in user

    visit article_path(article)

    within('.Comments-section') do
      assert page.has_content?('Kommentar erstellen')
    end
  end

  test "User can't create a comment on a vacationing seller's article" do
    article = create(:article, seller: create(:seller, vacationing: true))
    user = create(:user)
    sign_in user

    visit article_path(article)
    refute page.has_selector?('#new_comment_1')
  end

  test "A comment on a legal entity's article wont be shown after 5pm" do
    article = create(:article, seller: create(:legal_entity))
    user = create(:user)
    time5pm = (Time.now.utc.beginning_of_day + 17.hours)
    create(:comment, text: 'Earlier Comment', commentable: article, user: user,
                     created_at: time5pm - 1.minute)
    create(:comment, text: 'Later Comment', commentable: article, user: user,
                     created_at: time5pm + 1.minute)
    wait_for_comment_mails

    sign_in user

    Time.stubs(:now).returns(time5pm + 2.minutes)
    visit article_path(article)
    assert page.has_content? 'Earlier Comment'
    refute page.has_content? 'Later Comment'

    Time.stubs(:now).returns(time5pm + 1.day)
    visit article_path(article)
    assert page.has_content? 'Later Comment'
  end

  test "A comment on a legal entity's article wont be shown before 10am" do
    article = create(:article, seller: create(:legal_entity))
    user = create(:user)
    time10am = (Time.now.utc.beginning_of_day + 10.hours)
    create(:comment, text: 'Some Comment', commentable: article, user: user,
                     created_at: time10am - 2.minutes)
    wait_for_comment_mails

    sign_in user

    Time.stubs(:now).returns(time10am - 1.minute)
    visit article_path(article)
    refute page.has_content? 'Some Comment'

    Time.stubs(:now).returns(time10am + 1.minute)
    visit article_path(article)
    assert page.has_content? 'Some Comment'
  end

  # On comment creation mails are sent out. This can lead to
  # ActiveRecord::StatementInvalid: PG::InFailedSqlTransaction errors;
  # Sleep shortly here to avoid this!
  def wait_for_comment_mails
    sleep 1
  end
end
