#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class CommentLibrariesTest < ApplicationSystemTestCase
  before do
    UserTokenGenerator.stubs(:generate).returns('some long string that is very secret')
  end
  test 'Guest visits library with no comments' do
    library = create(:library, public: true)
    visit library_path(library)

    within('.Comments-section') do
      assert page.has_content?(I18n.t('comments.login_to_comment', href: I18n.t('comments.login_href')))
      page.wont_have_content(I18n.t('comments.create'))
    end
  end

  test 'Guest visits library with no comments' do
    library = create(:library, public: true)

    visit library_path(library)

    within('.Comments-section') do
      assert page.has_content?(I18n.t('comments.no_comments'))
    end
  end

  test 'Guest visits library with a comment' do
    library = create(:library, public: true)
    user = create(:user)
    create(:comment, text: 'Test comment', commentable: library, user: user)
    wait_for_comment_mails

    visit library_path(library)

    within('.Comments-section') do
      assert page.has_content?('Test comment')
      page.wont_have_content('Keine Kommentare')
      page.wont_have_content('Mehr Kommentare')
    end
  end

  test 'Guest visits library with more than 5 comments' do
    library = create(:library, public: true)
    user = create(:user)
    create_list(:comment, 10, text: 'Test comment', commentable: library, user: user)
    wait_for_comment_mails

    visit library_path(library)

    within('.Comments-section') do
      assert page.has_content?('Mehr Kommentare')
    end
  end

  test 'User visits library to create a comment' do
    library = create(:library, public: true)
    user = create(:user)
    sign_in user

    visit library_path(library)

    within('.Comments-section') do
      assert page.has_content?('Kommentar erstellen')
    end
  end

  test 'User is able to delete their own comment' do
    library = create(:library, public: true)
    user = create(:user)
    sign_in user
    create(:comment, text: 'Test comment', commentable: library, user: user)
    wait_for_comment_mails

    visit library_path(library)

    within('.Comments-section') do
      page.must_have_selector('.fa-times')
    end
  end

  test "Admin is able to delete another's comment" do
    library = create(:library, public: true)
    user = create(:admin_user)
    sign_in user
    create(:comment, text: 'Test comment', commentable: library, user: library.user)
    wait_for_comment_mails

    visit library_path(library)

    within('.Comments-section') do
      page.must_have_selector('.fa-times')
    end
  end

  test 'Guest is unable to delete a comment' do
    library = create(:library, public: true)
    user = create(:user)
    create(:comment, text: 'Test comment', commentable: library, user: user)
    wait_for_comment_mails

    visit library_path(library)

    within('.Comments-section') do
      refute page.has_selector?('.fa-times')
    end
  end

  test 'User is unable to delete other users comments' do
    library = create(:library, public: true)
    user = create(:user)
    user2 = create(:user)
    sign_in user2

    create(:comment, text: 'Test comment', commentable: library, user: user)
    wait_for_comment_mails

    visit library_path(library)

    within('.Comments-section') do
      page.wont_have_content('Kommentar löschen')
    end
  end

  # On comment creation mails are sent out. This can lead to
  # ActiveRecord::StatementInvalid: PG::InFailedSqlTransaction errors;
  # Sleep shortly here to avoid this!
  def wait_for_comment_mails
    sleep 1
  end
end
