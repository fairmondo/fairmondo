#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleContactTest < ApplicationSystemTestCase
  before do
    user = create :user
    sign_in user
    visit article_path create :article, :with_private_user
  end

  test 'user contacts seller' do
    fill_in 'contact_form[text]', with: 'foobar'
    click_button I18n.t('article.show.contact.action')

    assert page.has_content? I18n.t 'users.profile.contact.success_notice'
  end
end
