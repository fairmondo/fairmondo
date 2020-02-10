#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserNewsletterTest < ApplicationSystemTestCase
  setup do
    @user = create :user
    sign_in @user
  end
  test 'user wants to receive newsletter' do
    fixture = File.read('test/fixtures/cleverreach_add_success.xml')
    savon.expects(:receiver_add).with(message: :any).returns(fixture)

    visit edit_user_registration_path @user
    check 'user_newsletter', allow_label_click: true
    click_button I18n.t 'formtastic.actions.update'

    assert_equal true, @user.reload.newsletter
  end
  test 'user wants to unsubscribe to the newsletter' do
    fixture = File.read('test/fixtures/cleverreach_remove_success.xml')
    savon.expects(:receiver_delete).with(message: :any).returns(fixture)

    @user.update_column :newsletter, true
    visit edit_user_registration_path @user
    uncheck 'user_newsletter', allow_label_click: true
    click_button I18n.t 'formtastic.actions.update'

    assert_equal false, @user.reload.newsletter
  end
end
